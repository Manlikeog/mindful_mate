import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful_mate/data/model/progress_card/progress_card.dart';
import 'package:mindful_mate/providers/progress_card_provider.dart';
import 'package:mindful_mate/screens/chanllenges/chanllenge_screen.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/progress_card_provider.dart';
import 'package:mindful_mate/screens/chanllenges/chanllenge_screen.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class ChallengeCard extends ConsumerWidget {
  const ChallengeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressData = ref.watch(progressCardDataProvider);
    final currentLevel = progressData.level;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 4.pw(context), vertical: 2.ph(context)),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Card(
          key: ValueKey(progressData.activeChallenges.hashCode),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade50, Colors.yellow.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(4.pw(context)),
            child: currentLevel <= 3
                ? _buildChallengeContent(context, progressData, currentLevel)
                : _buildChampionContent(context, progressData, currentLevel),
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeContent(
      BuildContext context, ProgressCardData progressData, int currentLevel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.star,
                color: Colors.orange.shade600, size: 20.ww(context)),
            SizedBox(width: 2.pw(context)),
            Expanded(
              child: Text(
                'Level $currentLevel Challenges',
                style: TextStyle(
                  fontSize: 16.ww(context),
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.ph(context)),
        if (progressData.activeChallenges.isEmpty)
          Text(
            'No active challenges for Level $currentLevel. Level up soon! 🌟',
            style: TextStyle(
                fontSize: 14.ww(context), height: 1.4, color: Colors.black87),
          )
        else
          ...progressData.activeChallenges.map((challenge) {
            final challengeProgress =
                progressData.userProgress.challengeProgress[challenge.id] ?? 0;
            final isCompleted = progressData.userProgress.completedChallenges
                .contains(challenge.id);
            return Padding(
              padding: EdgeInsets.only(bottom: 2.ph(context)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                challenge.title,
                                style: TextStyle(
                                  fontSize: 14.ww(context),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 2.pw(context)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.pw(context),
                                  vertical: 0.5.ph(context)),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${challenge.points} pts',
                                style: TextStyle(
                                  fontSize: 12.ww(context),
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$challengeProgress/${challenge.goal} - ${challenge.description}',
                          style: TextStyle(
                              fontSize: 12.ww(context), color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Icon(Icons.check_circle,
                        color: Colors.green, size: 18.ww(context)),
                ],
              ),
            );
          }),
        SizedBox(height: 2.ph(context)),
        Text(
          'Progress: ${progressData.userProgress.totalPoints}/${progressData.levelTotalPoints}',
          style: TextStyle(fontSize: 12.ww(context), color: Colors.black87),
        ),
        SizedBox(height: 2.ph(context)),
        ElevatedButton(
          onPressed: () {
            context.push(ChallengesScreen.fullPath);
            
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade600,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: 4.pw(context), vertical: 1.ph(context)),
            textStyle: TextStyle(fontSize: 12.ww(context)),
          ),
          child: const Text('View All Challenges'),
        ),
      ],
    );
  }

  Widget _buildChampionContent(
      BuildContext context, ProgressCardData progressData, int currentLevel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 2.ph(context)),
        Icon(Icons.celebration,
            size: 40.ww(context), color: Colors.orange.shade600),
        SizedBox(height: 2.ph(context)),
        Text(
          'Legend Level ${currentLevel - 3} Master!',
          style: TextStyle(
            fontSize: 18.ww(context),
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade800,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.ph(context)),
        Text(
          'You’ve conquered all challenges! Keep your mindfulness streak alive or set your own goals. 🌟',
          style: TextStyle(
            fontSize: 14.ww(context),
            color: Colors.black87,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.ph(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.pw(context), vertical: 1.ph(context)),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Total Points: ${progressData.userProgress.totalPoints}',
                style: TextStyle(
                  fontSize: 14.ww(context),
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.ph(context)),
        ElevatedButton(
          onPressed: () {
            // Placeholder for future feature (e.g., custom challenges or reset)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Custom challenges coming soon!')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade600,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: 4.pw(context), vertical: 1.ph(context)),
            textStyle: TextStyle(fontSize: 12.ww(context)),
          ),
          child: const Text('Create Custom Challenges'),
        ),
      ],
    );
  }
}
