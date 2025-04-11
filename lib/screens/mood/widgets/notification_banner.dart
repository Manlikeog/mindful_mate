import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/mood_provider.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class NotificationBanner extends ConsumerWidget {
  const NotificationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastMoodLog = ref.watch(moodProvider.select((moods) => moods.isEmpty ? null : moods.keys.reduce((a, b) => a.isAfter(b) ? a : b)));

    if (lastMoodLog == null || DateTime.now().difference(lastMoodLog).inDays > 0) {
      return Card(
        color: Colors.yellow[100],
        margin: EdgeInsets.all(2.pw(context)), // Scaled margin
        child: Padding(
          padding: EdgeInsets.all(2.pw(context)), // Scaled padding
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 20.ww(context)), // Scaled icon
              SizedBox(width: 2.pw(context)), // Scaled spacing
              Expanded(
                child: Text(
                  'You haven’t logged your mood today!',
                  style: TextStyle(fontSize: 14.ww(context)), // Scaled text
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/mood_tracker'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.pw(context), vertical: 1.ph(context)), // Scaled padding
                  textStyle: TextStyle(fontSize: 12.ww(context)), // Scaled text
                ),
                child: const Text('Log Now'),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}