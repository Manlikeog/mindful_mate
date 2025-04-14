import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/controller/challenge_controller.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/providers/progress_provider.dart';

/// Provides access to the challenge controller.
final challengeControllerProvider = Provider((ref) => ChallengeController());

/// Provides the list of active challenges for the user's level.
final challengesProvider = Provider<List<Challenge>>((ref) {
  final progress = ref.watch(userProgressProvider);
  final controller = ref.watch(challengeControllerProvider);
  return controller.getChallengesForLevel(progress);
});