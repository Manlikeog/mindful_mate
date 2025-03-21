import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification/gamification_provider.dart';
import 'package:mindful_mate/providers/mood_tracker_provider.dart';
import 'package:mindful_mate/screens/relaxations/model/relaxation.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';

class RelaxationScreen extends ConsumerWidget {
  static List<RelaxationExercise> exercises = [
    RelaxationExercise(
      id: 'deep_breathing',
      title: 'Deep Breathing',
      description: 'Inhale for 4s, hold for 4s, exhale for 4s. Repeat 5 times.',
      duration: Duration(minutes: 2),
    ),
    RelaxationExercise(
      id: 'mindfulness',
      title: 'Mindfulness Moment',
      description: 'Focus on your breath for 5 minutes, letting thoughts pass.',
      duration: Duration(minutes: 5),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = injector.palette;
    final moodInsight = ref.getMoodInsight(ref.watch(currentDisplayedWeekProvider), ref.watch(calendarViewProvider));
    final suggestedExercise = moodInsight.contains('relaxation') ? exercises[0] : null;

    return Scaffold(
      appBar: AppBar(title: Text('Relaxation', style: TextStyle(color: palette.textColor))),
      body: ListView(
        children: [
          if (suggestedExercise != null) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Suggested: ${suggestedExercise.title}', style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
          ...exercises.map((exercise) => ListTile(
            title: Text(exercise.title),
            subtitle: Text('${exercise.duration.inMinutes} min'),
            onTap: () => _startRelaxation(context, ref, exercise),
          )),
        ],
      ),
    );
  }

  void _startRelaxation(BuildContext context, WidgetRef ref, RelaxationExercise exercise) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(exercise.title),
        content: Text(exercise.description),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(gamificationProvider.notifier).logActivity(activityType: 'relaxation');
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Relaxation completed! +20 points')));
            },
            child: Text('Complete'),
          ),
        ],
      ),
    );
  }
}