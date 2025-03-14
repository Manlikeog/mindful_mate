// lib/screens/challenges_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = injector.palette;
    final challenges = [
      {'title': 'Mood Streak', 'goal': 'Log mood 3 days in a row', 'reward': 30},
      {'title': 'Relaxation Master', 'goal': 'Complete 5 relaxation sessions', 'reward': 50},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.pureWhite,
        title: Text('Challenges', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(challenge['title'] as String),
              subtitle: Text(challenge['goal'] as String),
              trailing: Text('+${challenge['reward']} pts'),
              tileColor: palette.primaryColor.withOpacity(0.1),
            ),
          );
        },
      ),
    );
  }
}