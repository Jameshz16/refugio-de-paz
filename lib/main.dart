import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/config.dart';
import 'theme.dart';
import 'models/verse.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'services/settings_service.dart';
import 'screens/diary_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'services/ai_service.dart';
import 'widgets/animated_chick.dart';
import 'widgets/emotion_jar.dart';
import 'core/logger.dart';
import 'services/purchase_service.dart';
import 'package:home_widget/home_widget.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    LoggerService.info('Iniciando aplicación y entorno cargado...');

    await Firebase.initializeApp();

    // Initialize settings first
    final settingsService = SettingsService();
    await settingsService.init();
    LoggerService.info('Configuración cargada');

    final notificationService = NotificationService();
    await notificationService.init();
    LoggerService.info('Notificaciones iniciadas');
    if (settingsService.settings.notificationsEnabled) {
      await notificationService.scheduleDailyNotification();
      LoggerService.info('Notificaciones programadas');
    }

    // Inicializar el servicio de compras in-app con RevenueCat
    final purchaseService = PurchaseService();
    await purchaseService.initialize(apiKey: AppConfig.revenueCatApiKey);
    LoggerService.info('PurchaseService iniciado');
  } catch (e, stackTrace) {
    LoggerService.error('Error en main', error: e, stackTrace: stackTrace);
  }
  runApp(const RefugioDePazApp());
}

class RefugioDePazApp extends StatefulWidget {
  const RefugioDePazApp({super.key});

  @override
  State<RefugioDePazApp> createState() => _RefugioDePazAppState();
}

class _RefugioDePazAppState extends State<RefugioDePazApp> {
  final _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settingsService.settings;
    return MaterialApp(
      title: 'Bajo tus Alas',
      debugShowCheckedModeBanner: false,
      themeMode: _settingsService.themeMode,
      theme: CozyTheme.lightTheme(
        fontFamily: settings.fontFamily,
        fontScale: settings.fontScale,
        themeName: settings.themeName,
      ),
      darkTheme: CozyTheme.darkTheme(
        fontFamily: settings.fontFamily,
        fontScale: settings.fontScale,
        themeName: settings.themeName,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Stream<User?> _authStream;
  final _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges();
  }

  Future<void> _syncUserName(User user) async {
    // Solo guardar si el nombre aún está vacío en configuración
    if (_settingsService.settings.userName.isEmpty) {
      final name = user.displayName ?? user.email?.split('@').first ?? '';
      if (name.isNotEmpty) {
        await _settingsService.update(
          _settingsService.settings.copyWith(userName: name),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          _syncUserName(snapshot.data!);
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  final _aiService = AIService();
  final _settingsService = SettingsService();
  final TextEditingController _feelingController = TextEditingController();
  
  int _phase = 1;

  final List<Map<String, String>> _emotions = [
    {'name': 'Feliz', 'emoji': '😊', 'svg': 'assets/emotions/feliz.svg', 'color': '0xFF4CAF50'},
    {'name': 'Triste', 'emoji': '😢', 'svg': 'assets/emotions/triste.svg', 'color': '0xFF2196F3'},
    {'name': 'Ansioso', 'emoji': '😰', 'svg': 'assets/emotions/ansioso.svg', 'color': '0xFFFF9800'},
    {'name': 'Agradecido', 'emoji': '🙏', 'svg': 'assets/emotions/agradecido.svg', 'color': '0xFF9C27B0'},
    {'name': 'Cansado', 'emoji': '😴', 'svg': 'assets/emotions/cansado.svg', 'color': '0xFF607D8B'},
    {'name': 'Temeroso', 'emoji': '😨', 'svg': 'assets/emotions/temeroso.svg', 'color': '0xFFF44336'},
  ];
  
  String? _selectedEmotion;
  String? _selectedEmoji;
  String? _selectedSvg;
  bool _isLoading = false;
  Map<String, int> _emotionHistory = {};

  Verse? _currentVerse;

  @override
  void initState() {
    super.initState();
    _loadEmotionHistory();
    
    // Configurar Home Widget Group y Eventos
    HomeWidget.setAppGroupId('YOUR_GROUP_ID'); // Solo para iOS si se necesitara
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_checkForWidgetLaunch);
    HomeWidget.widgetClicked.listen(_checkForWidgetLaunch);
  }

  void _checkForWidgetLaunch(Uri? uri) {
    if (uri != null) {
      LoggerService.info('App lanzada desde Widget con URI: $uri');
      if (uri.host == 'emotion') {
        final emotionName = uri.queryParameters['name'];
        if (emotionName != null) {
          final emotionData = _emotions.firstWhere(
            (e) => e['name'] == emotionName,
            orElse: () => _emotions.first,
          );
          setState(() {
            _selectedEmotion = emotionData['name'];
            _selectedEmoji = emotionData['emoji'];
            _selectedSvg = emotionData['svg'];
            _phase = 2; // Saltar directamente a la escritura
          });
        }
      }
    }
  }

  Future<void> _loadEmotionHistory() async {
    final drops = await _storage.getEmotionDrops();
    final Map<String, int> historyCounts = {};
    for (var drop in drops) {
      final name = drop['name'] as String;
      historyCounts[name] = (historyCounts[name] ?? 0) + 1;
    }
    setState(() {
      _emotionHistory = historyCounts;
    });
  }

  Future<void> _saveEmotionToHistory(String emotion) async {
    await _storage.saveEmotionDrop(emotion);
    await _loadEmotionHistory(); // Recargar el estado para redibujar el Tarro
  }

  @override
  void dispose() {
    _feelingController.dispose();
    super.dispose();
  }

  int get _totalEmotions => _emotionHistory.values.fold(0, (a, b) => a + b);

  void _generateComfort() async {
    if (_feelingController.text.isEmpty || _selectedEmotion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, cuéntale a Dios lo que sientes.')),
      );
      return;
    }

    // Ocultar teclado
    FocusManager.instance.primaryFocus?.unfocus();

    await _saveEmotionToHistory(_selectedEmotion!);

    setState(() {
      _isLoading = true;
      _currentVerse = null;
    });

    final verse = await _aiService.getComfortingVerse(
      _feelingController.text, 
      _selectedEmotion!
    );

    setState(() {
      _isLoading = false;
      if (verse != null) {
        _currentVerse = verse;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hubo un error al buscar aliento. Intenta nuevamente.')),
        );
      }
    });
  }

  void _toggleFavorite() async {
    if (_currentVerse == null) return;
    setState(() {
      _currentVerse!.isFavorite = !_currentVerse!.isFavorite;
    });
    if (_currentVerse!.isFavorite) {
      await _storage.saveFavorite(_currentVerse!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guardado en tus favoritos ✨')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bajo tus Alas'),
        leading: _phase == 2 ? IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          tooltip: 'Volver a emociones',
          onPressed: () => setState(() {
            _phase = 1;
            _currentVerse = null;
          }),
        ) : null,
        actions: [
          if (_currentVerse != null)
            IconButton(
              icon: Icon(
                _currentVerse!.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _currentVerse!.isFavorite ? context.cozy.pastel : Theme.of(context).iconTheme.color,
              ),
              tooltip: _currentVerse!.isFavorite ? 'Quitar de favoritos' : 'Guardar en favoritos',
              onPressed: _toggleFavorite,
            ),
          IconButton(
            icon: Icon(Icons.collections_bookmark_rounded, color: Theme.of(context).iconTheme.color),
            tooltip: 'Ver favoritos',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings_rounded, color: Theme.of(context).iconTheme.color),
            tooltip: 'Configuración',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              // Reload emotion history in case it was cleared
              _loadEmotionHistory();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          children: [
            if (_phase == 1) ..._buildPhase1()
            else ..._buildPhase2(),
            if (_currentVerse != null) _buildVerseCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DiaryScreen()),
        ),
        label: const Text('Mi Diario'),
        icon: const Icon(Icons.auto_stories_rounded),
        backgroundColor: context.cozy.pastel,
        foregroundColor: context.cozy.textDark,
      ),
    );
  }

  List<Widget> _buildPhase1() {
    return [
      Text(
        '¿Cómo te sientes hoy?',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(height: 16),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: _emotions.length,
        itemBuilder: (context, index) {
          final emotion = _emotions[index];
          return InkWell(
            onTap: () {
              if (_settingsService.settings.hapticFeedbackEnabled) {
                HapticFeedback.lightImpact();
              }
              setState(() {
                _selectedEmotion = emotion['name'];
                _selectedEmoji = emotion['emoji'];
                _selectedSvg = emotion['svg'];
                _phase = 2;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: context.cozy.pastel.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Semantics(
                label: 'Emoción: ${emotion['name']}',
                button: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedChick(
                      emotionName: emotion['name']!,
                      size: 50,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      emotion['name']!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 24),
      // Gráfico de emociones (respeta configuración del usuario)
      if (_emotionHistory.isNotEmpty && _settingsService.settings.showEmotionChart)
        EmotionJar(
          emotionHistory: _emotionHistory,
          emotions: _emotions,
        ),
    ];
  }

  List<Widget> _buildPhase2() {
    return [
      Center(
        child: Column(
          children: [
            AnimatedChick(
              emotionName: _selectedEmotion ?? 'Feliz',
              size: 80,
            ),
            const SizedBox(height: 8),
            Text(
              'Te sientes $_selectedEmotion',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.7),
                  ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 32),
      Text(
        '¿Qué tienes para decirle a Dios hoy?',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(height: 16),
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.cozy.pastel.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _feelingController,
          maxLines: 4,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Escribe aquí tu sentir con confianza...',
            hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4)),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _isLoading ? null : _generateComfort,
          icon: _isLoading
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: context.cozy.textDark))
              : Icon(Icons.send_rounded, color: context.cozy.textDark),
          label: Text(
            _isLoading ? 'Elevando tu oración...' : 'Enviar mi corazón',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.cozy.textDark,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.cozy.pastel,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 2,
          ),
        ),
      ),
      const SizedBox(height: 32),
    ];
  }

  Widget _buildVerseCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color?.withOpacity(0.9) ?? Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.format_quote_rounded,
            size: 40,
            color: context.cozy.primary,
          ),
          const SizedBox(height: 16),
          Text(
            _currentVerse!.text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            _currentVerse!.reference,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CozyTheme.softBlue,
                ),
          ),
          if (_currentVerse!.prayer != null && _currentVerse!.prayer!.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            Text(
              'Palabras de aliento y Oración',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.cozy.accent,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentVerse!.prayer!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
