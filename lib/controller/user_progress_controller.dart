import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/repository/database_helper.dart';
import 'package:mindful_mate/utils/error_logger.dart';

class UserProgressController {
  final DatabaseHelper _databaseHelper;

  UserProgressController(this._databaseHelper);

  Future<UserProgress> fetchUserProgress() async {
    final stopwatch = Stopwatch()..start();
    try {
      final progress = await _databaseHelper.getUserProgress();
      log('Fetched user progress in ${stopwatch.elapsedMilliseconds}ms',
          level: 'info');
      return progress;
    } catch (e) {
      log('Failed to fetch user progress in ${stopwatch.elapsedMilliseconds}ms: $e',
          level: 'error');
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }

  Future<void> saveUserProgress(UserProgress progress) async {
    final stopwatch = Stopwatch()..start();
    try {
      await _databaseHelper.updateUserProgress(progress);
      log('Saved user progress in ${stopwatch.elapsedMilliseconds}ms',
          level: 'info');
    } catch (e) {
      log('Failed to save user progress in ${stopwatch.elapsedMilliseconds}ms: $e',
          level: 'error');
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }

  Future<void> resetProgress() async {
    final initialProgress = UserProgress();
    await saveUserProgress(initialProgress);
    log('User progress reset', level: 'info');
  }
}