import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/verse.dart';

class StorageService {
  static const String _favoritesKey = 'favorites';
  static const String _notesKey = 'diary_notes';

  Future<void> saveFavorite(Verse verse) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    // Evitar duplicados por referencia
    if (!favorites.any((v) => v.reference == verse.reference)) {
      favorites.add(verse);
      final jsonList = favorites.map((v) => jsonEncode(v.toJson())).toList();
      await prefs.setStringList(_favoritesKey, jsonList);
    }
  }

  Future<List<Verse>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favoritesKey) ?? [];
    return jsonList.map((j) => Verse.fromJson(jsonDecode(j))).toList();
  }

  Future<void> saveNote(String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(_notesKey) ?? [];
    
    // Si no hay título, autogeneramos uno a partir del contenido o la fecha
    String finalTitle = title.trim();
    if (finalTitle.isEmpty) {
      if (content.length > 20) {
        finalTitle = '${content.substring(0, 20)}...';
      } else {
        finalTitle = content;
      }
    }

    final note = jsonEncode({
      'title': finalTitle,
      'content': content,
      'date': DateTime.now().toIso8601String(),
    });
    notes.add(note);
    await prefs.setStringList(_notesKey, notes);
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_notesKey) ?? [];
    return jsonList.map((j) => jsonDecode(j) as Map<String, dynamic>).toList();
  }

  Future<void> deleteNote(Map<String, dynamic> noteToDelete) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_notesKey) ?? [];
    
    // Filtramos la nota buscando por su fecha exacta
    final updatedList = jsonList.where((jsonString) {
      final noteMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return noteMap['date'] != noteToDelete['date'];
    }).toList();
    
    await prefs.setStringList(_notesKey, updatedList);
  }

  Future<void> saveEmotionDrop(String emotionName) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('emotion_drops_list') ?? [];
    
    final drop = jsonEncode({
      'name': emotionName,
      'date': DateTime.now().toIso8601String(),
    });
    jsonList.add(drop);
    await prefs.setStringList('emotion_drops_list', jsonList);
  }

  Future<List<Map<String, dynamic>>> getEmotionDrops() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('emotion_drops_list') ?? [];
    return jsonList.map((j) => jsonDecode(j) as Map<String, dynamic>).toList();
  }
}
