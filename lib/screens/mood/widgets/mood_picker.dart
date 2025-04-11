import 'package:flutter/material.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/providers/mood_provider.dart';
import 'package:mindful_mate/screens/mood/mood_screen.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class MoodPicker extends StatelessWidget {
  final DateTime date;
  final MoodNotifier notifier;

  const MoodPicker({super.key, required this.date, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Log Mood',
        style: TextStyle(fontSize: 16.ww(context)), // Scaled text
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < 5; i++)
              IconButton(
                icon: Text(
                  ['😢', '😐', '😊', '😄', '🌟'][i],
                  style: TextStyle(fontSize: 24.ww(context)), // Scaled emoji
                ),
                padding: EdgeInsets.all(2.pw(context)), // Scaled padding
                constraints: BoxConstraints.tight(Size(12.pw(context), 12.pw(context))), // Scaled touch area
                onPressed: () {
                  notifier.logMood(MoodEntry(date: date, moodRating: i), context);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Mood logged!', style: TextStyle(fontSize: 14.ww(context))),
                        backgroundColor: Colors.grey,
                      ),
                    );
                    (context.findAncestorStateOfType<MoodTrackerScreenState>())?.showRewardAnimation();
                  }
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(fontSize: 14.ww(context))), // Scaled text
        ),
      ],
    );
  }

  static void show(BuildContext context, DateTime date, MoodNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => SizedBox(
        width: 80.pw(context), // Limit dialog width to 80% of screen
        child: MoodPicker(date: date, notifier: notifier),
      ),
    );
  }
}