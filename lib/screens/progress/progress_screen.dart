import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mindful_mate/screens/progress/widgets/challenge_card.dart';
import 'package:mindful_mate/screens/chanllenges/chanllenge_screen.dart';
import 'package:mindful_mate/screens/progress/widgets/insight_card.dart';
import 'package:mindful_mate/screens/progress/widgets/progress_card.dart';
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ProgressCard(),
          const InsightsCard(),
          const ChallengeCard(),
          const Gap(16),
          ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ChallengesScreen())),
            child: const Text('View Challenges'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RelaxationScreen())),
            child: const Text('Relaxation Exercises'),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
