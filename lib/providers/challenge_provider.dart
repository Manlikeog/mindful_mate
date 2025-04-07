import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/controller/challenge_controller.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';

final challengeControllerProvider = Provider((ref) => ChallengeController());

final challengesProvider = Provider<List<Challenge>>((ref) {
  final progress = ref.watch(gamificationProvider);
  final controller = ref.watch(challengeControllerProvider);
  return controller.getChallengesForLevel(progress);
});