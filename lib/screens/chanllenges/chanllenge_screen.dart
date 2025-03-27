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
      description: 'Log your mood 3 days this week.',
      goal: 3,
      type: 'mood_log',
      rewardPoints: 30,
      startDate: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)), // Start of week
      endDate: DateTime.now().add(Duration(days: 6 - DateTime.now().weekday)), // End of week
    ),
    Challenge(
      id: 'relax_day',
      title: 'Calm Mind',
      description: 'Complete 1 relaxation exercise today.',
      goal: 1,
      type: 'relaxation',
      rewardPoints: 20,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),
    Challenge(
      id: 'journal_day',
      title: 'Reflective Writer',
      description: 'Write 2 journal entries today.',
      goal: 2,
      type: 'journal',
      rewardPoints: 25,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ),
  ];

  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = injector.palette;
    final gamification = ref.watch(gamificationProvider.notifier);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Challenges', style: TextStyle(color: palette.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade50, Colors.yellow.shade50],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: challenges.map((challenge) {
            final progress = gamification.getChallengeProgress(challenge.id);
            final isCompleted = progress >= challenge.goal;
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCompleted
                        ? [Colors.green.shade100, Colors.green.shade50]
                        : [Colors.white, Colors.grey.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getChallengeIcon(challenge.type),
                          color: palette.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          challenge.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: palette.textColor,
                          ),
                        ),
                        if (isCompleted) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.check_circle, color: Colors.green, size: 20),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      challenge.description,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress / challenge.goal,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(palette.primaryColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$progress/${challenge.goal} (${(progress / challenge.goal * 100).toStringAsFixed(0)}%)',
                      style: TextStyle(fontSize: 14, color: palette.textColor),
                    ),
                    if (isCompleted)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Reward: ${challenge.rewardPoints} points earned!',
                          style: TextStyle(fontSize: 14, color: Colors.green.shade700),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getChallengeIcon(String type) {
    switch (type) {
      case 'mood_log':
        return Icons.mood;
      case 'relaxation':
        return Icons.self_improvement;
      case 'journal':
        return Icons.book;
      default:
        return Icons.star;
    }
  }
}