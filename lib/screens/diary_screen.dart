import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../services/storage_service.dart';
import '../services/settings_service.dart';
import '../theme.dart';
import 'premium_paywall_screen.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final _storage = StorageService();
  final _settingsService = SettingsService();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _saveNote() async {
    // Si hay contenido, guardamos. El título es opcional.
    if (_contentController.text.isNotEmpty) {
      await _storage.saveNote(_titleController.text, _contentController.text);
      _titleController.clear();
      _contentController.clear();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reflexión guardada con paz')),
        );
      }
    }
  }

  void _deleteNote(Map<String, dynamic> note) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar carta'),
        content: const Text('¿Estás seguro de que deseas borrar esta carta al cielo? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storage.deleteNote(note);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Carta borrada exitosamente')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Diario con Dios', style: GoogleFonts.lexend(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _storage.getNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 60, color: context.cozy.pastel),
                    const SizedBox(height: 20),
                    Text(
                      'Tus pensamientos están seguros aquí.\nEscribe tu primera carta al cielo.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                        fontSize: 18,
                        height: 1.5,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          final allNotes = snapshot.data!.reversed.toList();
          final isPremium = _settingsService.settings.isPremium;
          final hasReachedLimit = !isPremium && allNotes.length >= 10;
          final notes = hasReachedLimit ? allNotes.take(10).toList() : allNotes;
          final itemCount = hasReachedLimit ? notes.length + 1 : notes.length;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == notes.length && hasReachedLimit) {
                return Card(
                  elevation: 6,
                  color: context.cozy.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(Icons.lock_rounded, size: 48, color: context.cozy.accent),
                        const SizedBox(height: 16),
                        Text(
                          'Memoria Llena',
                          style: GoogleFonts.lexend(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: context.cozy.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Has alcanzado el límite gratuito de reflexiones. Desbloquea Bajo Tus Alas Premium para guardar y leer tu diario sin límites.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.cozy.textLight, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumPaywallScreen()));
                          },
                          icon: const Icon(Icons.star_rounded, color: Colors.white),
                          label: const Text('Descubrir Premium', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.cozy.accent,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final note = notes[index];
              // Alternar ligera rotación y margen para dar aspecto orgánico
              final isEven = index % 2 == 0;
              final rotation = isEven ? 0.015 : -0.015;

              return Transform.rotate(
                angle: rotation,
                child: Card(
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.1),
                  color: isDark ? Theme.of(context).cardColor : const Color(0xFFFFFDF5), // Color papel cálido solo en claro
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (note['title'].isNotEmpty && note['title'] != note['content'].substring(0, math.min(20, (note['content'] as String).length)) + '...') 
                              Expanded(
                                child: Text(note['title'], 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              )
                            else
                              const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: context.cozy.primary.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                note['date'].toString().split('T')[0],
                                style: TextStyle(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8)
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                              onPressed: () => _deleteNote(note),
                              tooltip: 'Borrar carta',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Querido Dios...',
                          style: GoogleFonts.lexend(
                            fontSize: 18, 
                            color: context.cozy.pastel,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          note['content'],
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            height: 1.6,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context),
        tooltip: 'Escribir nueva reflexión',
        backgroundColor: context.cozy.primary,
        child: const Icon(Icons.edit_note_rounded),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) async {
    final notes = await _storage.getNotes();
    final isPremium = _settingsService.settings.isPremium;
    if (!isPremium && notes.length >= 10) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Haz alcanzado el límite del diario. Actualiza a Premium 🔒')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumPaywallScreen()));
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFFFFDF5),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24, right: 24, top: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mi Carta a Dios', style: GoogleFonts.lexend(fontSize: 26, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: Theme.of(context).iconTheme.color),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Título (Opcional)',
                hintStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4)),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                autofocus: true,
                style: GoogleFonts.lexend(
                  fontSize: 20,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  hintText: 'Hoy tengo en mi corazón...',
                  hintStyle: GoogleFonts.lexend(fontSize: 20, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.3)),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_contentController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, escribe algo antes de guardar.')),
                      );
                      return;
                    }
                    _saveNote();
                  },
                  icon: const Icon(Icons.favorite_rounded, color: Colors.white),
                  label: const Text('Guardar Carta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.cozy.pastel,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
