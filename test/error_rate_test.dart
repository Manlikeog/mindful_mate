// test/error_rate_test.dart

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

  test('Error Rate', () async {
    UserProgress progress = container.read(userProgressProvider);
    final now = DateTime.now();
    int totalOps = 0;
    int errCount = 0;

    Future<void> attempt(String activityType) async {
      totalOps++;
      try {
        await controller.logActivity(
          progress: progress,
          activityType: activityType,
          activityDate: now,
          isSuggested: false,
        );
      } catch (_) {
        errCount++;
      }
    }

    await attempt('mood_log');
    await attempt('relaxation');
    await attempt('journal');

    final errorRate = totalOps > 0 ? errCount / totalOps * 100 : 0;
    print('Error Rate: ${errorRate.toStringAsFixed(2)}%');

    expect(errorRate, equals(0));
  });
}