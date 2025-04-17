import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/controller/gamification_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/providers/progress_provider.dart';
import 'package:mindful_mate/utils/error_logger.dart';

final gamificationControllerProvider = Provider((ref) {
  return GamificationController();
});

final gamificationProvider = Provider<Gamification>((ref) {
  return Gamification(ref);
});

class Gamification {
  final Ref providerRef;

  Gamification(this.providerRef);

  Future<UserProgress> logActivity(
    BuildContext context, {
    required String activityType,
    String? suggestedRelaxation,
    String? completedRelaxation,
    DateTime? activityDate,
    bool isSuggested = false,
  }) async {
    final controller = providerRef.read(gamificationControllerProvider);
    await providerRef.read(userProgressProvider.notifier).refresh();
    final progress = providerRef.read(userProgressProvider);

    log('Progress before log: level=${progress.level}, points=${progress.totalPoints}');
    final updatedProgress = controller.logActivity(
      progress: progress,
      activityType: activityType,
      suggestedRelaxation: suggestedRelaxation,
      completedRelaxation: completedRelaxation,
      activityDate: activityDate,
      isSuggested: isSuggested,
    );
    providerRef.read(userProgressProvider.notifier).update(updatedProgress);
    await providerRef.read(userProgressProvider.notifier).saveProgress();
    log('Logged activity: ${updatedProgress.challengeProgress}');
    return updatedProgress;
  }
}
