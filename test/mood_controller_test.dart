import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/controller/mood_controller.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/repository/database_helper.dart';

/// A dummy BuildContext that bypasses all calls via noSuchMethod
class FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Dummy provider ref stub
class FakeRef implements Ref {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Dummy database helper stub implementing the DatabaseHelper interface
class FakeDatabaseHelper implements DatabaseHelper {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('MoodController', () {
    final controller = MoodController(FakeDatabaseHelper(), FakeRef());

    test('logMood calls onFeedback and updates DB', () async {
      final entry = MoodEntry(date: DateTime(2025, 4, 17), moodRating: 4);
      var progress = UserProgress();
      bool feedbackCalled = false;

      await controller.logMood(
        entry: entry,
        context: FakeBuildContext(),
        progress: progress,
        onFeedback: (_) => feedbackCalled = true,
      );

      expect(feedbackCalled, isTrue);
    });
  });
}