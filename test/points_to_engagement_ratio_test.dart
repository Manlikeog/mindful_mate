import 'package:flutter_test/flutter_test.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/utils/date_utils.dart';
import 'package:collection/collection.dart';

void main() {
  group('📊 Points to Engagement Ratio Metrics', () {
    test('should calculate both raw and adjusted engagement ratios correctly', () async {
      final controller = GamificationController();

      var progress = UserProgress();

      // Use current week dates instead of future dates
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

      final activitySequence = [
        {'type': 'mood_log'},
        {'type': 'mood_log'},
        {'type': 'journal'},
        {'type': 'relaxation', 'completed': 'stretch_l1', 'suggested': true}, // Valid relaxation ID
        {'type': 'relaxation', 'completed': 'body_scan_l1', 'suggested': true}, // Valid relaxation ID
        {'type': 'relaxation', 'completed': 'breath_l1', 'suggested': true}, // Valid relaxation ID
      ];

      int effectiveEngagements = 0;
      int totalEngagements = 0;

      for (int i = 0; i < activitySequence.length; i++) {
        final entry = activitySequence[i];
        // Set dates within the current week
        final fakeDate = startOfWeek.add(Duration(days: i % 7));
        print(fakeDate);
        final beforeProgress = progress;

        progress = controller.logActivity(
          progress: progress,
          activityType: entry['type'] as String,
          completedRelaxation: entry['completed'] as String?,
          suggestedRelaxation: entry['completed'] as String?,
          activityDate: fakeDate,
          isSuggested: entry['suggested'] == true,
        );

        totalEngagements++;

        if (!MapEquality().equals(beforeProgress.challengeProgress, progress.challengeProgress)) {
          effectiveEngagements++;
        }
      }

      final rawRatio = progress.totalPoints / totalEngagements;
      final adjustedRatio = effectiveEngagements == 0 ? 0 : progress.totalPoints / effectiveEngagements;

      print('Total Points: ${progress.totalPoints}, Engagements: $totalEngagements, Effective: $effectiveEngagements');
      print('Raw Points-to-Engagement Ratio: ${rawRatio.toStringAsFixed(2)}');
      print('Adjusted Points-to-EffectiveEngagement Ratio: ${adjustedRatio.toStringAsFixed(2)}');

      expect(progress.totalPoints, greaterThan(0));
      expect(totalEngagements, equals(activitySequence.length));
      expect(effectiveEngagements <= totalEngagements, true);
      expect(rawRatio, greaterThan(0));
      expect(adjustedRatio, greaterThan(0));
    });
  });
}