import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/repository/database_helper.dart';
import 'package:mindful_mate/utils/error_logger.dart';

/// Manages user progress data operations.
class UserProgressController {
  final DatabaseHelper _databaseHelper;

  UserProgressController(this._databaseHelper);

  /// Fetches the current user progress from the database.
  Future<UserProgress> fetchUserProgress() async {
    try {
      final progress = await _databaseHelper.getUserProgress();
      ErrorLogger.logError('Fetched user progress: ${progress.totalPoints} points, level ${progress.level}');
      return progress;
    } catch (e) {
      ErrorLogger.logError('Failed to fetch user progress: $e', );
      rethrow;
    }
  }

  /// Saves the updated user progress to the database.
  Future<void> saveUserProgress(UserProgress progress) async {
    try {
      await _databaseHelper.updateUserProgress(progress);
      ErrorLogger.logError('Saved user progress: ${progress.totalPoints} points');
    } catch (e) {
      ErrorLogger.logError('Failed to save user progress: $e', );
      rethrow;
    }
  }

  /// Resets user progress to initial state (optional future feature).
  Future<void> resetProgress() async {
    final initialProgress = UserProgress();
    await saveUserProgress(initialProgress);
    ErrorLogger.logError('User progress reset');
  }
}