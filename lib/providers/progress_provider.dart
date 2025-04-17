import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/controller/user_progress_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/repository/database_helper.dart';

final databaseHelperProvider = Provider((ref) => HiveDatabaseHelper());

final userProgressControllerProvider = Provider((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return UserProgressController(dbHelper);
});

final userProgressProvider =
    StateNotifierProvider<UserProgressNotifier, UserProgress>((ref) {
  return UserProgressNotifier(ref);
});

class UserProgressNotifier extends StateNotifier<UserProgress> {
  final Ref providerRef;

  UserProgressNotifier(this.providerRef) : super(UserProgress()) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final controller = providerRef.read(userProgressControllerProvider);
    state = await controller.fetchUserProgress();
  }

  Future<void> refresh() async {
    final controller = providerRef.read(userProgressControllerProvider);
    state = await controller.fetchUserProgress();
  }

  Future<void> saveProgress() async {
    final controller = providerRef.read(userProgressControllerProvider);
    await controller.saveUserProgress(state);
  }

  void update(UserProgress progress) {
    state = progress;
    saveProgress();
  }
}