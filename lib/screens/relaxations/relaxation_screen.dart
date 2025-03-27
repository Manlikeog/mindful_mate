import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification/gamification_provider.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';
import 'package:mindful_mate/screens/chanllenges/model/chanllenge.dart'; // For levelRelaxations
import 'package:mindful_mate/screens/relaxations/model/relaxation.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';

class RelaxationScreen extends ConsumerWidget {
  final String? suggestedExerciseId;

  const RelaxationScreen({this.suggestedExerciseId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = injector.palette;
    final progress = ref.watch(gamificationProvider);
    final currentLevel = progress.level;
    final levelExercises = levelRelaxations[currentLevel] ?? [];

    final suggestedExercise = levelExercises.firstWhere(
      (e) => e.id == suggestedExerciseId,
      orElse: () => levelExercises.isNotEmpty ? levelExercises[0] : Relaxation(id: 'default', title: 'No Exercise', level: currentLevel),
    );
    final otherExercises = levelExercises.where((e) => e.id != suggestedExerciseId).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Level $currentLevel Relaxation', style: TextStyle(color: palette.textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.purple.shade50],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            if (suggestedExerciseId != null) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Suggested Relaxation (5-Point Booster)',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: palette.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              _buildRelaxationCard(context, ref, suggestedExercise, true, progress),
              const SizedBox(height: 16),
            ],
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Explore More',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: palette.textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...otherExercises.map((exercise) => _buildRelaxationCard(context, ref, exercise, false, progress)),
          ],
        ),
      ),
    );
  }

  Widget _buildRelaxationCard(
    BuildContext context,
    WidgetRef ref,
    Relaxation exercise,
    bool isSuggested,
    UserProgress progress,
  ) {
    final palette = injector.palette;
    final isCompletedToday = progress.completedRelaxations[exercise.id] != null &&
        isSameDay(progress.completedRelaxations[exercise.id]!, DateTime.now());
    final isExpanded = ref.watch(_expansionProvider(exercise.id));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: isSuggested ? 8 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSuggested
                  ? [Colors.purple.shade200, Colors.blue.shade200]
                  : [Colors.white, Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSuggested
                ? [BoxShadow(color: Colors.purple.shade100, blurRadius: 10, spreadRadius: 2)]
                : null,
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.self_improvement, color: palette.primaryColor, size: 32), // Generic icon for now
                title: Text(
                  exercise.title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: palette.textColor),
                ),
                subtitle: Text('Level ${exercise.level}', style: TextStyle(color: palette.textColor.withOpacity(0.7))),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isCompletedToday)
                      AnimatedScale(
                        scale: isCompletedToday ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(Icons.check_circle, color: Colors.green),
                      ),
                    IconButton(
                      icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: palette.textColor,
                      ),
                      onPressed: () {
                        ref.read(_expansionProvider(exercise.id).notifier).state = !isExpanded;
                      },
                    ),
                  ],
                ),
                onTap: () {
                  ref.read(_expansionProvider(exercise.id).notifier).state = !isExpanded;
                },
              ),
              AnimatedCrossFade(
                firstChild: Container(height: 0),
                secondChild: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete this to progress your relaxation challenge${isSuggested ? " and earn a 5-point booster" : ""}!',
                        style: TextStyle(color: palette.textColor.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          child: ElevatedButton(
                            onPressed: isCompletedToday
                                ? null
                                : () => _completeRelaxation(context, ref, exercise, isSuggested),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSuggested ? Colors.purple.shade600 : palette.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(isCompletedToday ? 'Done Today' : 'Start'),
                                if (isSuggested && !isCompletedToday) ...[
                                  const SizedBox(width: 8),
                                  AnimatedScale(
                                    scale: isSuggested ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 1000),
                                    curve: Curves.easeInOut,
                                    child: Icon(Icons.star, size: 16),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeRelaxation(BuildContext context, WidgetRef ref, Relaxation exercise, bool isSuggested) {
    ref.read(gamificationProvider.notifier).logActivity(
      activityType: 'relaxation',
      suggestedRelaxation: isSuggested ? exercise.id : null,
      completedRelaxation: exercise.id,
    );
    final progress = ref.read(gamificationProvider);
    final pointsAwarded = isSuggested && progress.completedRelaxations[exercise.id] != null &&
            isSameDay(progress.completedRelaxations[exercise.id]!, DateTime.now())
        ? 5
        : 0; // Only show booster points in feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Relaxation completed! ${pointsAwarded > 0 ? "+$pointsAwarded booster points" : "Check your challenge progress!"}',
        ),
        backgroundColor: pointsAwarded > 0 ? Colors.green : Colors.grey,
      ),
    );
  }
}

final _expansionProvider = StateProvider.family<bool, String>((ref, id) => false);

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}