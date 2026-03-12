import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../services/settings_service.dart';
import '../services/purchase_service.dart';
import '../models/user_settings.dart';
import 'premium_paywall_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  final _settingsService = SettingsService();
  late UserSettings _settings;
  final _nameController = TextEditingController();
  late AnimationController _headerAnimController;
  late Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();
    _settings = _settingsService.settings;
    _nameController.text = _settings.userName;

    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerFade = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOut,
    );
    _headerAnimController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headerAnimController.dispose();
    super.dispose();
  }

  Future<void> _updateSetting(UserSettings Function(UserSettings) updater) async {
    final newSettings = updater(_settings);
    setState(() => _settings = newSettings);
    await _settingsService.update(newSettings);
  }

  bool get _isDark {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark;
  }

  Color get _cardColor => context.cozy.surface;
  Color get _textColor => context.cozy.textDark;
  Color get _subtextColor => context.cozy.textLight;
  Color get _accentColor => context.cozy.accent;
  Color get _pinkAccent => context.cozy.pastel;
  Color get _bgColor => context.cozy.background;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: _textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // Header
          FadeTransition(
            opacity: _headerFade,
            child: _buildHeader(),
          ),
          const SizedBox(height: 24),

          // Profile
          _buildSectionTitle('👤', 'Perfil Personal'),
          const SizedBox(height: 8),
          _buildProfileSection(),
          const SizedBox(height: 24),

          // Appearance
          _buildSectionTitle('🎨', 'Apariencia'),
          const SizedBox(height: 8),
          _buildAppearanceSection(),
          const SizedBox(height: 24),

          // Notifications
          _buildSectionTitle('🔔', 'Notificaciones'),
          const SizedBox(height: 8),
          _buildNotificationsSection(),
          const SizedBox(height: 24),

          // Personalization
          _buildSectionTitle('📊', 'Personalización'),
          const SizedBox(height: 8),
          _buildPersonalizationSection(),
          const SizedBox(height: 24),

          // Data
          _buildSectionTitle('💾', 'Datos'),
          const SizedBox(height: 8),
          _buildDataSection(),
          const SizedBox(height: 24),

          // Premium
          if (!_settings.isPremium) ...[
            _buildSectionTitle('✨', 'Premium'),
            const SizedBox(height: 8),
            _buildPremiumBanner(),
            const SizedBox(height: 24),
          ],

          // About
          _buildSectionTitle('ℹ️', 'Sobre la App'),
          const SizedBox(height: 8),
          _buildAboutSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────

  Widget _buildHeader() {
    final name = _settings.userName.isNotEmpty ? _settings.userName : 'amigo(a)';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.cozy.primary.withOpacity(0.3),
            context.cozy.pastel.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              size: 30,
              color: _textColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola, $name 🕊️',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                ),
                const SizedBox(height: 4),
                if (_settings.isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [context.cozy.accent, context.cozy.pastel],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '✨ Miembro Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Text(
                    'Personaliza tu refugio',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _subtextColor,
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Title ──────────────────────────────────────

  Widget _buildSectionTitle(String emoji, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
          ),
        ],
      ),
    );
  }

  // ── Settings Card Wrapper ─────────────────────────────

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!_isDark)
            BoxShadow(
              color: context.cozy.pastel.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (iconColor ?? _accentColor).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor ?? _accentColor, size: 22),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _subtextColor,
                  ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      indent: 72,
      endIndent: 16,
      color: _subtextColor.withOpacity(0.1),
    );
  }

  // ── Profile Section ──────────────────────────────────

  Widget _buildProfileSection() {
    return _settingsCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _nameController,
            style: TextStyle(color: _textColor),
            decoration: InputDecoration(
              labelText: 'Tu nombre',
              labelStyle: TextStyle(color: _subtextColor),
              hintText: 'Escribe tu nombre...',
              hintStyle: TextStyle(color: _subtextColor.withOpacity(0.5)),
              prefixIcon: Icon(Icons.edit_rounded, color: _accentColor),
              filled: true,
              fillColor: _bgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: _accentColor, width: 1.5),
              ),
            ),
            onChanged: (value) {
              _updateSetting((s) => s.copyWith(userName: value));
            },
          ),
        ),
      ],
    );
  }

  // ── Appearance Section ────────────────────────────────

  Widget _buildAppearanceSection() {
    return _settingsCard(
      children: [
        // Theme Mode
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.palette_rounded, color: _accentColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Tema',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'light',
                      icon: Icon(Icons.light_mode_rounded, size: 18),
                      label: Text('Claro'),
                    ),
                    ButtonSegment(
                      value: 'system',
                      icon: Icon(Icons.phone_android_rounded, size: 18),
                      label: Text('Auto'),
                    ),
                    ButtonSegment(
                      value: 'dark',
                      icon: Icon(Icons.dark_mode_rounded, size: 18),
                      label: Text('Oscuro'),
                    ),
                  ],
                  selected: {_settings.themeMode},
                  onSelectionChanged: (selection) {
                    HapticFeedback.selectionClick();
                    _updateSetting((s) => s.copyWith(themeMode: selection.first));
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _divider(),

        // Theme Name (Visual Themes)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                   Container(
                     width: 40,
                     height: 40,
                     decoration: BoxDecoration(
                       color: _accentColor.withOpacity(0.15),
                       borderRadius: BorderRadius.circular(12),
                     ),
                     child: Icon(Icons.format_paint_rounded, color: _accentColor, size: 22),
                   ),
                   const SizedBox(width: 12),
                   Text(
                     'Temas Visuales',
                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                           fontWeight: FontWeight.w600,
                           color: _textColor,
                         ),
                   ),
                ],
              ),
              const SizedBox(height: 12),
              _buildThemeNameOptions(),
            ],
          ),
        ),
        _divider(),

        // Font Family
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _pinkAccent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.font_download_rounded,
                        color: _pinkAccent,
                        size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Tipografía',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._buildFontOptions(),
            ],
          ),
        ),
        _divider(),

        // Font Scale
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.text_fields_rounded, color: _accentColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Tamaño de texto',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('A', style: TextStyle(fontSize: 12, color: _subtextColor)),
                  Expanded(
                    child: Slider(
                      value: _settings.fontScale,
                      min: 0.85,
                      max: 1.25,
                      divisions: 4,
                      activeColor: _accentColor,
                      inactiveColor: _subtextColor.withOpacity(0.2),
                      label: _fontScaleLabel(_settings.fontScale),
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        _updateSetting((s) => s.copyWith(fontScale: value));
                      },
                    ),
                  ),
                  Text('A', style: TextStyle(fontSize: 22, color: _subtextColor)),
                ],
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Vista previa del texto ✨',
                    style: TextStyle(
                      fontSize: 16 * _settings.fontScale,
                      color: _textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _fontScaleLabel(double scale) {
    if (scale <= 0.87) return 'Pequeño';
    if (scale <= 0.95) return 'Casi normal';
    if (scale <= 1.05) return 'Normal';
    if (scale <= 1.17) return 'Grande';
    return 'Muy grande';
  }

  Widget _buildThemeNameOptions() {
    final themes = [
      {'name': 'cream', 'label': 'Crema Suave', 'color': CozyPalette.cream.surface, 'isPremium': false, 'desc': 'Tonos cálidos y naturales'},
      {'name': 'sunrise', 'label': 'Amanecer Dorado', 'color': CozyPalette.sunrise.surface, 'isPremium': true, 'desc': 'Tonos naranjas llenos de esperanza'},
      {'name': 'forest', 'label': 'Bosque Sereno', 'color': CozyPalette.forest.surface, 'isPremium': true, 'desc': 'Tonos verdes que brindan paz'},
      {'name': 'night', 'label': 'Noche de Paz', 'color': CozyPalette.night.surface, 'isPremium': true, 'desc': 'Azules profundos para descansar'},
      {'name': 'spring', 'label': 'Primavera en Flor', 'color': CozyPalette.spring.surface, 'isPremium': true, 'desc': 'Lilas y rosas para el alma'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: themes.map((theme) {
          final isSelected = _settings.themeName == theme['name'];
          final isPremium = theme['isPremium'] as bool;
          final isLocked = isPremium && !_settings.isPremium;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                if (isLocked) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumPaywallScreen()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Este tema es exclusivo de Bajo Tus Alas Premium 🔒')),
                  );
                  return;
                }
                _updateSetting((s) => s.copyWith(themeName: theme['name'] as String));
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (theme['color'] as Color),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? context.cozy.textDark : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    if (isLocked)
                      const Icon(Icons.lock_rounded, color: Colors.black54, size: 24)
                    else if (isSelected)
                      const Icon(Icons.check_circle_rounded, color: Colors.black87, size: 24)
                    else
                      const SizedBox(height: 24),
                    const SizedBox(height: 8),
                    Text(
                      theme['label'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildFontOptions() {
    const fonts = [
      {'name': 'Lexend', 'label': 'Lexend', 'desc': 'Moderna y limpia'},
      {'name': 'Caveat', 'label': 'Caveat', 'desc': 'Escrita a mano'},
      {'name': 'Dancing Script', 'label': 'Dancing Script', 'desc': 'Elegante y cursiva'},
    ];

    return fonts.map((font) {
      final isSelected = _settings.fontFamily == font['name'];
      TextStyle previewStyle;
      switch (font['name']) {
        case 'Caveat':
          previewStyle = GoogleFonts.caveat(fontSize: 18, color: _textColor);
          break;
        case 'Dancing Script':
          previewStyle = GoogleFonts.dancingScript(fontSize: 18, color: _textColor);
          break;
        default:
          previewStyle = GoogleFonts.lexend(fontSize: 16, color: _textColor);
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _updateSetting((s) => s.copyWith(fontFamily: font['name']));
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? _accentColor.withOpacity(0.15) : _bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? _accentColor : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(font['label']!, style: previewStyle),
                      Text(
                        font['desc']!,
                        style: TextStyle(fontSize: 12, color: _subtextColor),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: _accentColor, size: 22),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  // ── Notifications Section ─────────────────────────────

  Widget _buildNotificationsSection() {
    return _settingsCard(
      children: [
        _settingsTile(
          icon: Icons.notifications_active_rounded,
          title: 'Recordatorio diario',
          subtitle: _settings.notificationsEnabled
              ? 'Activo a las ${_settings.notificationHour}:00'
              : 'Desactivado',
          trailing: Switch(
            value: _settings.notificationsEnabled,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              _updateSetting((s) => s.copyWith(notificationsEnabled: value));
            },
          ),
        ),
        if (_settings.notificationsEnabled) ...[
          _divider(),
          _settingsTile(
            icon: Icons.access_time_rounded,
            title: 'Hora del recordatorio',
            subtitle: '${_settings.notificationHour}:00',
            trailing: Icon(Icons.chevron_right_rounded, color: _subtextColor),
            onTap: () => _showTimePicker(),
          ),
        ],
      ],
    );
  }

  Future<void> _showTimePicker() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _settings.notificationHour, minute: 0),
      helpText: 'Hora del recordatorio',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      _updateSetting((s) => s.copyWith(notificationHour: time.hour));
    }
  }

  // ── Personalization Section ───────────────────────────

  Widget _buildPersonalizationSection() {
    return _settingsCard(
      children: [
        _settingsTile(
          icon: Icons.insert_chart_rounded,
          title: 'Historial emocional',
          subtitle: 'Mostrar gráfico en el inicio',
          trailing: Switch(
            value: _settings.showEmotionChart,
            onChanged: (value) {
              _updateSetting((s) => s.copyWith(showEmotionChart: value));
            },
          ),
        ),
        _divider(),
        _settingsTile(
          icon: Icons.vibration_rounded,
          title: 'Vibración háptica',
          subtitle: 'Al seleccionar emociones',
          trailing: Switch(
            value: _settings.hapticFeedbackEnabled,
            onChanged: (value) {
              if (value) HapticFeedback.lightImpact();
              _updateSetting((s) => s.copyWith(hapticFeedbackEnabled: value));
            },
          ),
        ),
      ],
    );
  }

  // ── Data Section ──────────────────────────────────────

  Widget _buildDataSection() {
    return _settingsCard(
      children: [
        _settingsTile(
          icon: Icons.delete_sweep_rounded,
          title: 'Borrar historial emocional',
          subtitle: 'Reiniciar el registro de emociones',
          iconColor: Colors.orange,
          trailing: Icon(Icons.chevron_right_rounded, color: _subtextColor),
          onTap: () => _confirmAction(
            title: '¿Borrar historial emocional?',
            message: 'Se eliminará el registro de emociones. Esta acción no se puede deshacer.',
            onConfirm: () async {
              await _settingsService.clearEmotionHistory();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Historial emocional borrado')),
                );
              }
            },
          ),
        ),
        _divider(),
        _settingsTile(
          icon: Icons.warning_amber_rounded,
          title: 'Borrar todos los datos',
          subtitle: 'Eliminar configuración, diario y favoritos',
          iconColor: Colors.redAccent,
          trailing: Icon(Icons.chevron_right_rounded, color: _subtextColor),
          onTap: () => _confirmAction(
            title: '⚠️ ¿Borrar TODOS los datos?',
            message:
                'Se eliminarán todas tus reflexiones, favoritos, historial emocional y configuración.\n\nEsta acción es IRREVERSIBLE.',
            isDestructive: true,
            onConfirm: () async {
              await _settingsService.clearAllData();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Todos los datos han sido borrados')),
                );
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _confirmAction({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(title, style: TextStyle(fontSize: 18, color: _textColor)),
        content: Text(message, style: TextStyle(color: _subtextColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar', style: TextStyle(color: _subtextColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Confirmar',
              style: TextStyle(
                color: isDestructive ? Colors.redAccent : _accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) onConfirm();
  }

  // ── Premium Banner ─────────────────────────────────────

  Widget _buildPremiumBanner() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PremiumPaywallScreen()),
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.cozy.accent.withOpacity(0.15),
              context.cozy.pastel.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: context.cozy.accent.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.cozy.accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                color: context.cozy.accent,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Únete a Bajo Tus Alas Premium',
                    style: GoogleFonts.lexend(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Temas exclusivos, diario ilimitado y más.',
                    style: TextStyle(fontSize: 13, color: _subtextColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: _accentColor),
          ],
        ),
      ),
    );
  }

  // ── About Section ─────────────────────────────────────

  Widget _buildAboutSection() {
    return _settingsCard(
      children: [
        _settingsTile(
          icon: Icons.info_outline_rounded,
          title: 'Versión',
          subtitle: '1.0.0',
        ),
        _divider(),
        _settingsTile(
          icon: Icons.restore_rounded,
          title: 'Restaurar compras',
          subtitle: 'Si ya eres Premium, recupéralo aquí',
          trailing: Icon(Icons.chevron_right_rounded, color: _subtextColor),
          onTap: () async {
            await PurchaseService().restorePurchases();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Solicitud de restauración enviada. Espera un momento...'),
                ),
              );
            }
          },
        ),
        _divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Column(
              children: [
                Text(
                  '🪺',
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bajo Tus Alas',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hecho con ❤️ y fe',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _subtextColor,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\"Él te cubrirá con sus plumas\ny bajo sus alas hallarás refugio\"',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: _subtextColor,
                        height: 1.5,
                      ),
                ),
                Text(
                  'Salmos 91:4',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _accentColor,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
