import 'package:flutter_test/flutter_test.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/utils/date_utils.dart';

void main() {
  group('🎯 Challenge Completion Rate Metric', () {
    test('calculates completion rate from a sequence of logged activities', () async {
      final controller = GamificationController();

      var progress = UserProgress();

         // Use current week dates instead of future dates
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

      final activitySequence = [
        {'type': 'mood_log'},
        {'type': 'mood_log'},
        {'type': 'mood_log'},
        {'type': 'journal'},
        {'type': 'journal'},
        {'type': 'journal'},
       // Valid relaxation ID
        {'type': 'relaxation', 'completed': 'breath_l1', 'suggested': true},
         {'type': 'relaxation', 'completed': 'breath_l1', 'suggested': true},
          {'type': 'relaxation', 'completed': 'breath_l1', 'suggested': true}, // Valid relaxation ID
      ];

      for (int i = 0; i < activitySequence.length; i++) {
        final entry = activitySequence[i];
       // Set dates within the current week
        final fakeDate = startOfWeek.add(Duration(days: i % 7));
        print(fakeDate);

        progress = controller.logActivity(
          progress: progress,
          activityType: entry['type'] as String,
          completedRelaxation: entry['completed'] as String?,
          suggestedRelaxation: entry['completed'] as String?,
          activityDate: fakeDate,
          isSuggested: entry['suggested'] == true,
        );
      }

      final totalChallenges = 4; // Expected for level 1
      final completedCount = progress.completedChallenges.length;
      final completionRate = completedCount / totalChallenges;

      print('Completed Challenges: $completedCount / $totalChallenges');
      print('Simulated Challenge Completion Rate: ${(completionRate * 100).toStringAsFixed(2)}%');

      expect(completedCount, lessThanOrEqualTo(totalChallenges));
      expect(completionRate, inInclusiveRange(0, 1));
    });
  });
}
//   test('calculates completion rate from a sequence of logged activities with no completions', () async {
//     final controller = GamificationController();
//
//     var progress = UserProgress(
//       level: 1,              
//       totalPoints: 0,
//       streakCount: 0,
//       lastLogDate: null,
//       lastMoodLogDate: null,
//       lastRelaxationLogDate: null,