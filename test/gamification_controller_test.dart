import 'package:flutter_test/flutter_test.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/utils/date_utils.dart';

void main() {
  final controller = GamificationController();
  group('GamificationController _logMood', () {
    test('awards 2 points on first mood log today', () {
      final day = DateTime.now();
      var progress = UserProgress();
      progress = controller.logActivity(
        progress: progress,
        activityType: 'mood_log',
        activityDate: day,
        isSuggested: false,
      );
      expect(progress.totalPoints, 2);
      expect(progress.moodLogDates, contains(DateTime(2025,4,22)));
    });

    test('double mood log same day gives no extra points', () {
      final day = DateTime.now();
      var progress = UserProgress();
      progress = controller.logActivity(progress: progress, activityType: 'mood_log', activityDate: day, isSuggested: false);
      final second = controller.logActivity(progress: progress, activityType: 'mood_log', activityDate: day, isSuggested: false);
      expect(second.totalPoints, 2);
    });
  });

  group('Streak and Level Up', () {
    test('streak resets after a missed day', () {
      var p = UserProgress();
      p = controller.logActivity(progress: p, activityType: 'mood_log', activityDate: DateTime(2025,4,19), isSuggested: false);
      p = controller.logActivity(progress: p, activityType: 'journal', activityDate: DateTime(2025,4,21), isSuggested: false);
      expect(p.streakCount, 1);
    });

    test('level up when reaching passMarks threshold', () {
      var p = UserProgress(totalPoints: 99, level: 1);
      p = controller.logActivity(progress: p, activityType: 'mood_log', activityDate: DateTime(2025,4,21), isSuggested: false);
      expect(p.level, greaterThan(1));
      expect(p.badges, isNotEmpty);
    });
  });
}