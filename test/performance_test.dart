import 'package:flutter_test/flutter_test.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';

void main() {
  test('logActivity performance under 50ms', () {
    final controller = GamificationController();
    final start = DateTime.now().millisecondsSinceEpoch;
    controller.logActivity(
      progress: UserProgress(),
      activityType: 'mood_log',
      activityDate: DateTime.now(),
      isSuggested: false,
    );
    final elapsed = DateTime.now().millisecondsSinceEpoch - start;
    expect(elapsed, lessThan(50));
  });
}