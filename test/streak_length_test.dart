// test/streak_length_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';
import 'package:mindful_mate/providers/progress_provider.dart';
import 'fakes/fake_database_helper.dart';

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late ProviderContainer container;
  late GamificationController controller;

  setUp(() {
    container = ProviderContainer(overrides: [
      databaseHelperProvider.overrideWithProvider(
        Provider((ref) => FakeDatabaseHelper()),
      ),
    ]);
    controller = container.read(gamificationControllerProvider);
  });

  tearDown(() {
    container.dispose();
  });

  test('Simulated Streak Length', () async {
    UserProgress progress = container.read(userProgressProvider);
    const days = 5;

    // Log at least one activity each consecutive day
    for (int i = 0; i < days; i++) {
      final date = DateTime.now().add(Duration(days: i));
      progress = await controller.logActivity(
        progress: progress,
        activityType: 'mood_log',
        activityDate: date,
        isSuggested: false,
      );
    }

    final streak = progress.streakCount;
    print('Simulated Streak Length: $streak days');

    expect(streak, equals(days));
  });
}
