// test/code_execution_time_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';
import 'package:mindful_mate/providers/progress_provider.dart';
import 'fakes/fake_database_helper.dart';

/// Test for Code Execution Time metric
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

  test('Code Execution Time', () async {
    UserProgress progress = container.read(userProgressProvider);
    final now = DateTime.now();
    List<int> execTimes = [];

    Future<void> measure(String activityType, {String? relaxationId, bool isSuggested = false}) async {
      final start = DateTime.now().millisecondsSinceEpoch;
      await controller.logActivity(
        progress: progress,
        activityType: activityType,
        activityDate: now,
        completedRelaxation: relaxationId,
        isSuggested: isSuggested,
      );
      execTimes.add(DateTime.now().millisecondsSinceEpoch - start);
    }

    await measure('mood_log');
    await measure('relaxation', relaxationId: 'breath_l1', isSuggested: true);
    await measure('journal');

    final totalTime = execTimes.fold(0, (a, b) => a + b);
    final avgTime = execTimes.isNotEmpty ? totalTime / execTimes.length : 0;

    print('Code Execution Times: $execTimes');
    print('Average Execution Time: ${avgTime.toStringAsFixed(2)} ms');

    expect(avgTime, greaterThan(0));
  });
}