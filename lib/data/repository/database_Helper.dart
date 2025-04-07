import 'package:hive/hive.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';

abstract class DatabaseHelper {
  Future<List<MoodEntry>> getMoodEntries();
  Future<void> saveMoodEntry(MoodEntry entry);
  Future<List<JournalEntry>> getJournalEntries();
  Future<List<JournalEntry>> fetchJournalEntriesWithoutContext(); // Added
  Future<void> saveJournalEntry(JournalEntry entry);
  Future<void> deleteJournalEntry(String id);
  Future<UserProgress> getUserProgress();
  Future<UserProgress> fetchUserProgressWithoutContext(); // Added
  Future<void> updateUserProgress(UserProgress progress);
  Future<List<Challenge>> getChallenges();
  Future<void> saveChallenge(Challenge challenge);
  Future<void> deleteChallenge(String id);
  Future<List<Relaxation>> getRelaxations();
  Future<void> saveRelaxation(Relaxation relaxation);
}

class HiveDatabaseHelper implements DatabaseHelper {
  static final HiveDatabaseHelper _instance = HiveDatabaseHelper._internal();
  factory HiveDatabaseHelper() => _instance;

  HiveDatabaseHelper._internal();

  Box<JournalEntry> get _journalBox => Hive.box<JournalEntry>('journals');
  Box<UserProgress> get _progressBox => Hive.box<UserProgress>('user_progress');
  Box<MoodEntry> get _moodBox => Hive.box<MoodEntry>('moods');
  Box<Challenge> get _challengeBox => Hive.box<Challenge>('challenges');
  Box<Relaxation> get _relaxationBox => Hive.box<Relaxation>('relaxations');

  @override
  Future<List<MoodEntry>> getMoodEntries() async {
    return _moodBox.values.toList();
  }

  @override
  Future<void> saveMoodEntry(MoodEntry entry) async {
    await _moodBox.put(entry.date.toIso8601String(), entry);
  }

  @override
  Future<List<JournalEntry>> getJournalEntries() async {
    return _journalBox.values.toList();
  }

  @override
  Future<List<JournalEntry>> fetchJournalEntriesWithoutContext() async {
    return _journalBox.values.toList();
  }

  @override
  Future<void> saveJournalEntry(JournalEntry entry) async {
    await _journalBox.put(entry.id, entry);
  }

  @override
  Future<void> deleteJournalEntry(String id) async {
    await _journalBox.delete(id);
  }

  @override
  Future<UserProgress> getUserProgress() async {
    return _progressBox.get('current') ?? UserProgress();
  }

  @override
  Future<UserProgress> fetchUserProgressWithoutContext() async {
    return _progressBox.get('current') ?? UserProgress();
  }

  @override
  Future<void> updateUserProgress(UserProgress progress) async {
    await _progressBox.put('current', progress);
  }

  @override
  Future<List<Challenge>> getChallenges() async {
    return _challengeBox.values.toList();
  }

  @override
  Future<void> saveChallenge(Challenge challenge) async {
    await _challengeBox.put(challenge.id, challenge);
  }

  @override
  Future<void> deleteChallenge(String id) async {
    await _challengeBox.delete(id);
  }

  @override
  Future<List<Relaxation>> getRelaxations() async {
    return _relaxationBox.values.isNotEmpty
        ? _relaxationBox.values.toList()
        : levelRelaxations.values.expand((r) => r).toList();
  }

  @override
  Future<void> saveRelaxation(Relaxation relaxation) async {
    await _relaxationBox.put(relaxation.id, relaxation);
  }
}