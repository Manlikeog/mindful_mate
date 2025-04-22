import 'package:flutter_test/flutter_test.dart';
import 'package:mindful_mate/controller/challenge_controller.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';

void main() {
  final cc = ChallengeController();
  group('ChallengeController', () {
    test('returns no challenges for undefined level', () {
      final prog = UserProgress(level: 999);
      final filtered = cc.getChallengesForLevel(prog);
      expect(filtered, isEmpty);
    });

    test('completes relaxation challenge when goal reached', () {
      final now = DateTime.now();
      // Patch challenges and relaxations to be active
      final origChallenges = List<Challenge>.from(levelChallenges[1]!);
      levelChallenges[1]!.clear();
      levelChallenges[1]!.addAll(origChallenges.map((c) =>
        c.copyWith(
          startDate: now.subtract(Duration(days: 1)),
          endDate: now.add(Duration(days: 1)),
        )
      ));
      levelRelaxations[1] = [
        Relaxation(
          id: 'relax_l1',
          title: 'Test Relax',
          level: 1,
          duration: 5,
          description: 'Desc',
        ),
      ];

      final challenge = levelChallenges[1]!
          .firstWhere((c) => c.id == 'relax_l1');
      final goal = challenge.goal;

      var progress = UserProgress(level: 1);
      for (int i = 0; i < goal; i++) {
        progress = cc.updateChallengeProgress(
          progress: progress,
          activityType: 'relaxation',
          now: now,
          completedRelaxation: 'relax_l1',
        );
      }

      expect(progress.completedChallenges, contains('relax_l1'));
      expect(progress.challengeProgress['relax_l1'], goal);
    });
  });
}