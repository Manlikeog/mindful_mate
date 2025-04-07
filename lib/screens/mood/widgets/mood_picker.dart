// lib/screens/mood_picker.dart
import 'package:flutter/material.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/providers/mood_provider.dart';
import 'package:mindful_mate/screens/mood/mood_screen.dart';

class MoodPicker extends StatelessWidget {
  final DateTime date;
  final MoodNotifier notifier;

  const MoodPicker({super.key, required this.date, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Mood'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < 5; i++)
            IconButton(
              icon: Text(['😢', '😐', '😊', '😄', '🌟'][i],
                  style: const TextStyle(fontSize: 24)),
              onPressed: () {
                notifier.logMood(MoodEntry(date: date, moodRating: i), context);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mood logged!'),
                      backgroundColor: Colors.grey,
                    ),
                  );
                  (context.findAncestorStateOfType<MoodTrackerScreenState>())
                      ?.showRewardAnimation();
                }
                Navigator.pop(context);
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  static void show(BuildContext context, DateTime date, MoodNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => MoodPicker(date: date, notifier: notifier),
    );
  }
}
