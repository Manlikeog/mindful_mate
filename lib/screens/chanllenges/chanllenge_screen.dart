import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class ChallengesScreen extends ConsumerWidget {
  static const String fullPath = '/challenges';
  static const String path = 'challenges';
  static const String pathName = '/challenges';

  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = injector.palette;
    final progress = ref.watch(gamificationProvider);
    final currentLevel = progress.level;
    final challenges = levelChallenges[currentLevel] ?? [];
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Level $currentLevel Challenges', style: TextStyle(color: palette.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade50, Colors.green.shade50],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.pw(context), vertical: 2.ph(context)),
              child: Column(
                children: challenges.map((challenge) {
                  final challengeProgress = progress.challengeProgress[challenge.id] ?? 0;
                  final isCompleted = progress.completedChallenges.contains(challenge.id);
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    margin: EdgeInsets.symmetric(vertical: 1.ph(context)),
                    child: Container(
                      width: screenWidth > 600 ? 600 : double.infinity, // Cap width on large screens
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
                      padding: EdgeInsets.all(4.pw(context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getChallengeIcon(challenge.type),
                                color: palette.primaryColor,
                                size: 24.ww(context),
                              ),
                              SizedBox(width: 2.pw(context)),
                              Expanded(
                                child: Text(
                                  challenge.title,
                                  style: TextStyle(
                                    fontSize: 18.ww(context),
                                    fontWeight: FontWeight.bold,
                                    color: palette.textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isCompleted) ...[
                                SizedBox(width: 2.pw(context)),
                                Icon(Icons.check_circle, color: Colors.green, size: 20.ww(context)),
                              ],
                            ],
                          ),
                          SizedBox(height: 2.ph(context)),
                          Text(
                            challenge.description,
                            style: TextStyle(fontSize: 14.ww(context), color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 2.ph(context)),
                          LinearProgressIndicator(
                            value: challengeProgress / challenge.goal,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation(palette.primaryColor),
                          ),
                          SizedBox(height: 2.ph(context)),
                          Text(
                            '$challengeProgress/${challenge.goal} (${(challengeProgress / challenge.goal * 100).toStringAsFixed(0)}%)',
                            style: TextStyle(fontSize: 14.ww(context), color: palette.textColor),
                          ),
                          if (isCompleted)
                            Padding(
                              padding: EdgeInsets.only(top: 2.ph(context)),
                              child: Text(
                                'Completed: ${challenge.points} points earned!',
                                style: TextStyle(fontSize: 14.ww(context), color: Colors.green.shade700),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getChallengeIcon(String type) {
    switch (type) {
      case 'mood_log': return Icons.mood;
      case 'relaxation': return Icons.self_improvement;
      case 'journal': return Icons.book;
      default: return Icons.star;
    }
  }
}