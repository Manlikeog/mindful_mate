import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification/gamification_provider.dart';
import 'package:mindful_mate/screens/chanllenges/model/chanllenge.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';

class ChallengesScreen extends ConsumerWidget {
  static final List<Challenge> challenges = [
    Challenge(
      id: 'mood_week',
      title: 'Mood Tracker',
      description: 'Log your mood 5 days this week.',
      goal: 5,
      type: 'mood_log',
      rewardPoints: 30,
      startDate: DateTime(2025, 3, 10),
      endDate: DateTime(2025, 3, 16),
    ),
    Challenge(
      id: 'relax_week',
      title: 'Calm Mind',
      description: 'Complete 2 relaxation exercises this week.',
      goal: 2,
      type: 'relaxation',
      rewardPoints: 40,
      startDate: DateTime(2025, 3, 10),
      endDate: DateTime(2025, 3, 16),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = injector.palette;
    final gamification = ref.watch(gamificationProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Challenges', style: TextStyle(color: palette.textColor))),
      body: ListView(
        children: challenges.map((challenge) {
          final progress = gamification.getChallengeProgress(challenge.id);
          return ListTile(
            title: Text(challenge.title),
            subtitle: Text('$progress/${challenge.goal} - ${challenge.description}'),
            trailing: progress >= challenge.goal ? Icon(Icons.check, color: palette.primaryColor) : null,
          );
        }).toList(),
      ),
    );
  }
}