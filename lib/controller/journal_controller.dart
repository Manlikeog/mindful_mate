import 'package:flutter/material.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/data/repository/database_helper.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:uuid/uuid.dart';

class JournalController {
  final DatabaseHelper _dbHelper;
  final GamificationController _gamificationController;

  JournalController(this._dbHelper)
      : _gamificationController = GamificationController(_dbHelper);

  JournalEntry createNewEntry({
    required DateTime date,
    required String title,
    required String content,
    required int? moodIndex,
    required bool isBold,
    required bool isItalic,
  }) {
    return JournalEntry(
      id: const Uuid().v4(),
      date: date,
      title: title.isEmpty ? null : title,
      content: content,
      moodIndex: moodIndex,
      isBold: isBold,
      isItalic: isItalic,
    );
  }

  Future<List<JournalEntry>> fetchJournalEntries() async {
    return await _dbHelper.getJournalEntries();
  }

  Future<void> saveJournalEntry(
    BuildContext context,
    JournalEntry entry, {
    required UserProgress progress,
    required Function(String) onFeedback,
  }) async {
    await _dbHelper.saveJournalEntry(entry);
    final updatedProgress = _gamificationController.logActivity(
      context: context,
      progress: progress,
      activityType: 'journal',
      activityDate: entry.date
    );
    _gamificationController.saveUserProgress(updatedProgress);
    onFeedback('Journal entry saved successfully!');
  }

  Future<void> deleteJournalEntry(String id) async {
    await _dbHelper.deleteJournalEntry(id);
  }

  Future<List<JournalEntry>> filterEntriesByDate(List<JournalEntry> entries, DateTime date) async {
    return entries.where((entry) => isSameDay(entry.date, date)).toList();
  }

 Future<List<JournalEntry>> filterEntriesBySearchQuery(List<JournalEntry> entries, String searchQuery) async {
    final lowerQuery = searchQuery.toLowerCase();
    return entries
        .where((entry) =>
            entry.content.toLowerCase().contains(lowerQuery) ||
            (entry.title?.toLowerCase() ?? '').contains(lowerQuery))
        .toList();
  }

  List<JournalEntry> sortEntries(List<JournalEntry> entries, bool descending) {
    return entries..sort((a, b) => descending ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}