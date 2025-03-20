import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/gamification/gamification_provider.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(gamificationProvider);
    final palette = injector.palette;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: palette.textColor)),
          const SizedBox(height: 16),
          Text('Level: ${progress.level}'),
          Text('Streak: ${progress.streakCount} days'),
          Text('Points: ${progress.totalPoints}'),
          const SizedBox(height: 16),
          Text('Badges:', style: Theme.of(context).textTheme.titleLarge),
          Wrap(
            spacing: 8,
            children: progress.badges.map((badge) => Chip(label: Text(badge))).toList(),
          ),
        ],
      ),
    );
  }
}