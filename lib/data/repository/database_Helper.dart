import 'package:hive/hive.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';
import 'package:mindful_mate/utils/error_logger.dart';

/// Exception thrown for database errors.
class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}

/// Interface for database operations.
abstract class DatabaseHelper {
  Future<List<MoodEntry>> getMoodEntries();
  Future<void> saveMoodEntry(MoodEntry entry);
  Future<List<JournalEntry>> getJournalEntries();
  Future<List<JournalEntry>> fetchJournalEntriesWithoutContext();
  Future<void> saveJournalEntry(JournalEntry entry);
  Future<void> deleteJournalEntry(String id);
  Future<UserProgress> getUserProgress();
  Future<UserProgress> fetchUserProgressWithoutContext();
  Future<void> updateUserProgress(UserProgress progress);
  Future<List<Challenge>> getChallenges();
  Future<void> saveChallenge(Challenge challenge);
  Future<void> deleteChallenge(String id);
  Future<List<Relaxation>> getRelaxations();
  Future<void> saveRelaxation(Relaxation relaxation);
}

/// Hive-based implementation of DatabaseHelper.
class HiveDatabaseHelper implements DatabaseHelper {
  static final HiveDatabaseHelper _instance = HiveDatabaseHelper._internal();
  factory HiveDatabaseHelper() => _instance;

  HiveDatabaseHelper._internal();

  UserProgress? _cachedProgress;

  Box<JournalEntry> get _journalBox => Hive.box<JournalEntry>('journals');
  Box<UserProgress> get _progressBox => Hive.box<UserProgress>('user_progress');
  Box<MoodEntry> get _moodBox => Hive.box<MoodEntry>('moods');
  Box<Challenge> get _challengeBox => Hive.box<Challenge>('challenges');
  Box<Relaxation> get _relaxationBox => Hive.box<Relaxation>('relaxations');

  @override
  Future<List<MoodEntry>> getMoodEntries() async {
    try {
      return _moodBox.values.toList();
    } catch (e) {
       ErrorLogger.logError('Failed to get mood entries: $e', );
      throw DatabaseException('Unable to retrieve mood entries');
    }
  }

  @override
  Future<void> saveMoodEntry(MoodEntry entry) async {
    try {
      await _moodBox.put(entry.key, entry);
    } catch (e) {
       ErrorLogger.logError('Failed to save mood entry: $e', );
      throw DatabaseException('Unable to save mood entry');
    }
  }

  @override
  Future<List<JournalEntry>> getJournalEntries() async {
    try {
      return _journalBox.values.toList();
    } catch (e) {
       ErrorLogger.logError('Failed to get journal entries: $e', );
      throw DatabaseException('Unable to retrieve journal entries');
    }
  }

  @override
  Future<List<JournalEntry>> fetchJournalEntriesWithoutContext() async {
    return getJournalEntries();
  }

  @override
  Future<void> saveJournalEntry(JournalEntry entry) async {
    try {
      await _journalBox.put(entry.id, entry);
    } catch (e) {
       ErrorLogger.logError('Failed to save journal entry: $e', );
      throw DatabaseException('Unable to save journal entry');
    }
  }

  @override
  Future<void> deleteJournalEntry(String id) async {
    try {
      await _journalBox.delete(id);
    } catch (e) {
       ErrorLogger.logError('Failed to delete journal entry: $e', );
      throw DatabaseException('Unable to delete journal entry');
    }
  }

  @override
  Future<UserProgress> getUserProgress() async {
    try {
      if (_cachedProgress != null) return _cachedProgress!;
      _cachedProgress = _progressBox.get('current') ?? UserProgress();
      return _cachedProgress!;
    } catch (e) {
       ErrorLogger.logError('Failed to get user progress: $e', );
      throw DatabaseException('Unable to retrieve user progress');
    }
  }

  @override
  Future<UserProgress> fetchUserProgressWithoutContext() async {
    return getUserProgress();
  }

  @override
  Future<void> updateUserProgress(UserProgress progress) async {
    try {
      _cachedProgress = progress;
      await _progressBox.put('current', progress);
    } catch (e) {
       ErrorLogger.logError('Failed to update user progress: $e', );
      throw DatabaseException('Unable to update user progress');
    }
  }

  @override
  Future<List<Challenge>> getChallenges() async {
    try {
      return _challengeBox.values.toList();
    } catch (e) {
       ErrorLogger.logError('Failed to get challenges: $e', );
      throw DatabaseException('Unable to retrieve challenges');
    }
  }

  @override
  Future<void> saveChallenge(Challenge challenge) async {
    try {
      await _challengeBox.put(challenge.id, challenge);
    } catch (e) {
       ErrorLogger.logError('Failed to save challenge: $e', );
      throw DatabaseException('Unable to save challenge');
    }
  }

  @override
  Future<void> deleteChallenge(String id) async {
    try {
      await _challengeBox.delete(id);
    } catch (e) {
       ErrorLogger.logError('Failed to delete challenge: $e', );
      throw DatabaseException('Unable to delete challenge');
    }
  }

  @override
  Future<List<Relaxation>> getRelaxations() async {
    try {
      if (_relaxationBox.isEmpty) {
        final relaxations = levelRelaxations.values.expand((r) => r).toList();
        for (var relaxation in relaxations) {
          await _relaxationBox.put(relaxation.id, relaxation);
        }
      }
      return _relaxationBox.values.toList();
    } catch (e) {
       ErrorLogger.logError('Failed to get relaxations: $e', );
      throw DatabaseException('Unable to retrieve relaxations');
    }
  }

  @override
  Future<void> saveRelaxation(Relaxation relaxation) async {
    try {
      await _relaxationBox.put(relaxation.id, relaxation);
    } catch (e) {
       ErrorLogger.logError('Failed to save relaxation: $e', );
      throw DatabaseException('Unable to save relaxation');
    }
  }
}