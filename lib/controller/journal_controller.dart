import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/repository/database_helper.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';
import 'package:mindful_mate/utils/date_utils.dart';
import 'package:mindful_mate/utils/error_logger.dart';
import 'package:uuid/uuid.dart';

/// Manages journal-related operations, including creation, saving, and filtering.
class JournalController {
  final DatabaseHelper _databaseHelper;
  final Ref providerRef;

  JournalController(this._databaseHelper, this.providerRef);

  /// Creates a new journal entry with the specified details.
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

  /// Fetches all journal entries from the database.
  Future<List<JournalEntry>> fetchJournalEntries() async {
    return await _databaseHelper.getJournalEntries();
  }

  /// Saves a journal entry and updates user progress.
  Future<void> saveJournalEntry(
    BuildContext context,
    JournalEntry entry, {
    required UserProgress progress,
    required Function(String) onFeedback,
  }) async {
    try {
      await _databaseHelper.saveJournalEntry(entry);
      final updatedProgress =
          await providerRef.read(gamificationProvider).logActivity(
                context,
                activityType: 'journal',
                activityDate: entry.date,
              );
      final isToday = isSameDay(entry.date, DateTime.now());
      final pointsAwarded = updatedProgress.totalPoints - progress.totalPoints;
      final feedback = isToday
          ? pointsAwarded <= 0
              ? 'Journal updated for today, no additional points awarded.'
              : 'Journal entry saved! +3 points'
          : 'Previous day journal logged, no points awarded.';
      onFeedback(feedback);
    } catch (e) {
      ErrorLogger.logError(
        'Retry failed for relaxation: $e',
      );
      onFeedback('Error checking journal entry: $e');
      return;
    }
  }

  /// Deletes a journal entry by its ID.
  Future<void> deleteJournalEntry(String id) async {
    await _databaseHelper.deleteJournalEntry(id);
  }

  /// Filters journal entries by a specific date.
  Future<List<JournalEntry>> filterEntriesByDate(
    List<JournalEntry> entries,
    DateTime date,
  ) async {
    return entries.where((entry) => isSameDay(entry.date, date)).toList();
  }

  /// Filters journal entries by a search query.
  Future<List<JournalEntry>> filterEntriesBySearchQuery(
    List<JournalEntry> entries,
    String searchQuery,
  ) async {
    final lowerQuery = searchQuery.toLowerCase();
    return entries
        .where((entry) =>
            entry.content.toLowerCase().contains(lowerQuery) ||
            (entry.title?.toLowerCase() ?? '').contains(lowerQuery))
        .toList();
  }

  /// Sorts journal entries by date.
  List<JournalEntry> sortEntries(List<JournalEntry> entries, bool descending) {
    return entries
      ..sort((a, b) =>
          descending ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
  }
}
