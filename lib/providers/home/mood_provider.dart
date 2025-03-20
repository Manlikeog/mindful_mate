import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/screens/mood/model/mood_entry.dart';
import 'package:mindful_mate/repository/database_helper.dart';

class MoodNotifier extends StateNotifier<Map<DateTime, MoodEntry>> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  MoodNotifier() : super({}) {
    _loadMoods();
  }

  Future<void> _loadMoods() async {
    final moodEntries = await _dbHelper.getMoodEntries();
    state = {for (var entry in moodEntries) entry.date: entry};
  }

  void logMood(MoodEntry entry) {
    state = {...state, entry.date: entry};
    _dbHelper.saveMoodEntry(entry);
    HapticFeedback.lightImpact();
  }
}

final moodProvider = StateNotifierProvider<MoodNotifier, Map<DateTime, MoodEntry>>((ref) => MoodNotifier());