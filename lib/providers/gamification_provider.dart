import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/providers/data_provider.dart';

final gamificationControllerProvider = Provider((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return GamificationController(dbHelper);
});

final gamificationProvider = StateNotifierProvider<GamificationNotifier, UserProgress>((ref) {
  return GamificationNotifier(ref);
});

class GamificationNotifier extends StateNotifier<UserProgress> {
  final Ref ref;

  GamificationNotifier(this.ref) : super(UserProgress()) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final controller = ref.read(gamificationControllerProvider);
    try {
      final progress = await controller.fetchUserProgress();
      state = progress;
      print('Loaded progress: ${progress.challengeProgress}');
    } catch (e) {
      print('Initial progress load failed: $e');
    }
  }

  Future<void> refresh() async {
    final controller = ref.read(gamificationControllerProvider);
    final progress = await controller.fetchUserProgress();
    state = progress;
    print('Refreshed progress: ${progress.challengeProgress}');
  }

  Future<void> logActivity(
    BuildContext context, {
    required String activityType,
    String? suggestedRelaxation,
    String? completedRelaxation,
    DateTime? activityDate,
  }) async {
    final controller = ref.read(gamificationControllerProvider);
    final updatedProgress = controller.logActivity(
      context: context,
      progress: state,
      activityType: activityType,
      suggestedRelaxation: suggestedRelaxation,
      completedRelaxation: completedRelaxation,
      activityDate: activityDate,
    );
    state = updatedProgress;
    await controller.saveUserProgress(updatedProgress);
    print('Logged activity: ${updatedProgress.challengeProgress}');
  }
}