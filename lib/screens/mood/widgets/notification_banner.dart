// lib/screens/notification_banner.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/mood_provider.dart';

class NotificationBanner extends ConsumerWidget {
  const NotificationBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastMoodLog = ref.watch(moodProvider.select((moods) => moods.isEmpty ? null : moods.keys.reduce((a, b) => a.isAfter(b) ? a : b)));

    if (lastMoodLog == null || DateTime.now().difference(lastMoodLog).inDays > 0) {
      return Card(
        color: Colors.yellow[100],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.warning, color: Colors.orange),
              const SizedBox(width: 8),
              const Expanded(child: Text('You haven’t logged your mood today!')),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/mood_tracker'),
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