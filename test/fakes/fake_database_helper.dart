// test/fakes/fake_database_helper.dart

import 'package:mindful_mate/data/repository/database_helper.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';

/// A fake in-memory implementation of HiveDatabaseHelper for testing.
class FakeDatabaseHelper implements HiveDatabaseHelper {
  UserProgress _progress = UserProgress();
  final List<MoodEntry> _moodEntries = [];
  final List<JournalEntry> _journalEntries = [];
  final List<Relaxation> _relaxations = [];

  @override
  Future<UserProgress> getUserProgress() async => _progress;

  @override
  Future<UserProgress> fetchUserProgressWithoutContext() async => _progress;

  @override
  Future<void> updateUserProgress(UserProgress progress) async {
    _progress = progress;
  }

  @override
  Future<void> saveMoodEntry(MoodEntry entry) async {
    _moodEntries.add(entry);
  }

  @override
  Future<List<MoodEntry>> getMoodEntries() async => _moodEntries;

  @override
  Future<void> saveJournalEntry(JournalEntry entry) async {
    _journalEntries.add(entry);
  }

  @override
  Future<List<JournalEntry>> getJournalEntries() async => _journalEntries;

  @override
  Future<List<JournalEntry>> fetchJournalEntriesWithoutContext() async => _journalEntries;

  @override
  Future<void> deleteJournalEntry(String id) async {
    _journalEntries.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> saveRelaxation(Relaxation relaxation) async {
    _relaxations.add(relaxation);
  }

  @override
  Future<List<Relaxation>> getRelaxations() async => _relaxations;

  @override
  Future<List<Challenge>> getChallenges() async {
    // Return challenges for the current user level.
    return levelChallenges[_progress.level] ?? [];
  }

  @override
  Future<void> saveChallenge(Challenge challenge) async {
    // No-op for testing
  }

  @override
  Future<void> deleteChallenge(String id) async {
    // No-op for testing
  }
}