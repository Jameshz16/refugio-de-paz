import 'package:flutter/material.dart';
import '../models/verse.dart';
import '../services/storage_service.dart';
import '../theme.dart';

class FavoritesScreen extends StatelessWidget {
  final _storage = StorageService();

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Versículos')),
      body: FutureBuilder<List<Verse>>(
        future: _storage.getFavorites(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aún no has guardado versículos.'));
          }
          final verses = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: verses.length,
            itemBuilder: (context, index) {
              final verse = verses[index];
              return Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(Icons.favorite, color: context.cozy.pastel),
                  title: Text(verse.text, style: const TextStyle(fontStyle: FontStyle.italic)),
                  subtitle: Text(verse.reference, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
