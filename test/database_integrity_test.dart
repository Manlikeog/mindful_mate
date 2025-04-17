// test/database_integrity_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';

import 'fakes/fake_database_helper.dart';

void main() {
  late FakeDatabaseHelper db;

  setUp(() {
    db = FakeDatabaseHelper();
  });

  test('MoodEntry save and retrieval', () async {
    final entry = MoodEntry(date: DateTime(2025, 4, 1), moodRating: 3);
    await db.saveMoodEntry(entry);
    final list = await db.getMoodEntries();
    expect(list.length, 1);
    expect(list.first.moodRating, equals(3));
    expect(list.first.date, equals(DateTime(2025, 4, 1)));
  });

  test('JournalEntry save and retrieval', () async {
    final journal = JournalEntry(
      id: 'j1',
      date: DateTime(2025, 4, 2),
      title: 'Test',
      content: 'Content',
      moodIndex: 2,
      isBold: true,
      isItalic: false,
    );
    await db.saveJournalEntry(journal);
    final list = await db.getJournalEntries();
    expect(list.length, 1);
    expect(list.first.id, equals('j1'));
    expect(list.first.content, equals('Content'));
  });

  test('Relaxation save and retrieval', () async {
    final relaxation = Relaxation(
      id: 'r1',
      title: 'Test Relax',
      level: 1,
      duration: 5,
      description: 'Desc',
    );
    await db.saveRelaxation(relaxation);
    final list = await db.getRelaxations();
    expect(list.length, 1);
    expect(list.first.id, equals('r1'));
    expect(list.first.title, equals('Test Relax'));
  });

  test('UserProgress get, update, fetch', () async {
    final initial = await db.getUserProgress();
    expect(initial.totalPoints, equals(0));

    final updated = initial.copyWith(totalPoints: 42, streakCount: 5);
    await db.updateUserProgress(updated);
    final fetched = await db.getUserProgress();
    expect(fetched.totalPoints, equals(42));
    expect(fetched.streakCount, equals(5));
  });

  test('Get Challenges for level', () async {
    // FakeDatabaseHelper returns levelChallenges[_progress.level]
    // Default UserProgress.level is 1
    final challenges = await db.getChallenges();
    expect(challenges, isNotEmpty);
    expect(challenges.every((c) => c.type.isNotEmpty), isTrue);
  });
}
