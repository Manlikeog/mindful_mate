import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = injector.palette;
    final progress = ref.watch(gamificationProvider);
    final currentLevel = progress.level;
    final challenges = levelChallenges[currentLevel] ?? [];
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Level $currentLevel Challenges', style: TextStyle(color: palette.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.green.shade50],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: challenges.map((challenge) {
            final challengeProgress = progress.challengeProgress[challenge.id] ?? 0;
            final isCompleted = progress.completedChallenges.contains(challenge.id);
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
                      value: challengeProgress / challenge.goal,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(palette.primaryColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$challengeProgress/${challenge.goal} (${(challengeProgress / challenge.goal * 100).toStringAsFixed(0)}%)',
                      style: TextStyle(fontSize: 14, color: palette.textColor),
                    ),
                    if (isCompleted)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Completed: ${challenge.points} points earned!',
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