import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/progress_provider.dart';
import 'package:mindful_mate/screens/chanllenges/chanllenge_screen.dart';

class ChallengeCard extends ConsumerWidget {
  const ChallengeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressData = ref.watch(progressCardDataProvider);
    final currentLevel = progressData.level;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Card(
          key: ValueKey(progressData.activeChallenges.hashCode),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade50,
                  Colors.yellow.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange.shade600),
                    const SizedBox(width: 12),
                    Text(
                      'Level $currentLevel Challenges',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (progressData.activeChallenges.isEmpty)
                  Text(
                    'No active challenges for Level $currentLevel. Level up soon! 🌟',
                    style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
                  )
                else
                  ...progressData.activeChallenges.map((challenge) {
                    final challengeProgress = progressData.userProgress.challengeProgress[challenge.id] ?? 0;
                    final isCompleted = progressData.userProgress.completedChallenges.contains(challenge.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0), // Note: 'bottom' instead of 'custom' might be intended
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  challenge.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  '$challengeProgress/${challenge.goal} - ${challenge.description}',
                                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          if (isCompleted)
                            const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 16),
                Text(
                  'Progress: ${progressData.userProgress.totalPoints}/${progressData.levelTotalPoints}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChallengesScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('View All Challenges'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}