import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/controller/relaxation_controller.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation_card.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';
import 'package:mindful_mate/providers/progress_provider.dart';

/// Provides access to the relaxation controller.
final relaxationControllerProvider = Provider((ref) {
  final gamificationController = ref.watch(gamificationControllerProvider);
  return RelaxationController(gamificationController, ref);
});

/// Manages expansion state for relaxation cards.
final expansionProvider = StateProvider.family<bool, String>((ref, id) => false);

/// Provides data for the relaxation screen.
final relaxationScreenProvider = Provider.family((ref, String? suggestedExerciseId) {
  final progress = ref.watch(userProgressProvider);
  final controller = ref.watch(relaxationControllerProvider);
  final currentLevel = progress.level;
  final levelExercises = levelRelaxations[currentLevel] ?? [];

  RelaxationCardData buildRelaxationCardData(
    Relaxation exercise,
    bool isSuggested,
  ) {
    final isCompletedToday = controller.isCompletedToday(progress, exercise.id);
    final isExpanded = ref.watch(expansionProvider(exercise.id));

    return RelaxationCardData(
      exercise: exercise,
      isSuggested: isSuggested,
      isCompletedToday: isCompletedToday,
      isExpanded: isExpanded,
      toggleExpansion: () =>
          ref.read(expansionProvider(exercise.id).notifier).state = !isExpanded,
      completeRelaxation: (context) {
        controller.completeRelaxation(
          context: context,
          progress: progress,
          exercise: exercise,
          isSuggested: isSuggested,
          onFeedback: (message) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: message.contains('no ') ? Colors.black : Colors.green,
            ),
          ),
        );
       
      },
    );
  }

  final suggestedExercise = levelExercises.firstWhere(
    (e) => e.id == suggestedExerciseId,
    orElse: () => levelExercises.isNotEmpty
        ? levelExercises[0]
        : Relaxation(
            id: 'default',
            title: 'No Exercise',
            level: currentLevel,
            description: '',
            duration: 0,
          ),
  );
  final otherExercises = levelExercises.where((e) => e.id != suggestedExerciseId).toList();

  return {
    'currentLevel': currentLevel,
    'suggestedCard': suggestedExerciseId != null
        ? buildRelaxationCardData(suggestedExercise, true)
        : null,
    'otherCards': otherExercises.map((e) => buildRelaxationCardData(e, false)).toList(),
  };
});