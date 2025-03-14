// lib/screens/mood_tracker_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mindful_mate/providers/gamification/gamification_provider.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';
import 'package:mindful_mate/screens/mood/model/insight_card.dart';
import 'package:mindful_mate/screens/mood/model/mood_calendar.dart';
import 'package:mindful_mate/screens/mood/model/trend_chart.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:confetti/confetti.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';

class MoodTrackerScreen extends ConsumerStatefulWidget {
  static const String path = 'moodTracker';
  static const String fullPath = '/moodTracker';
  static const String pathName = '/moodTracker';
  const MoodTrackerScreen({super.key});

  @override
  MoodTrackerScreenState createState() => MoodTrackerScreenState();
}

class MoodTrackerScreenState extends ConsumerState<MoodTrackerScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(gamificationProvider);
    final palette = injector.palette;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: palette.pureWhite,
        title: Text(
          'Mood History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: injector.palette.textColor,
              ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildProgressCard(progress, palette),
                const MoodCalendar(),
                const TrendChart(),
                const InsightsCard(),
                const Gap(16),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: [
                palette.primaryColor,
                palette.secondaryColor,
                palette.accentColor
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(UserProgress progress, Palette palette) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Your Progress',
                style: Theme.of(context).textTheme.titleLarge),
            const Gap(8),
            LinearProgressIndicator(
              value: (progress.totalPoints % 100) / 100,
              backgroundColor: palette.dividerColor,
              valueColor: AlwaysStoppedAnimation(palette.primaryColor),
            ),
            const Gap(8),
            Text(
                'Level ${progress.level} | Streak: ${progress.streakCount} days'),
            Text('Points: ${progress.totalPoints}'),
            const Gap(8),
            Wrap(
              spacing: 8,
              children: progress.badges
                  .map((badge) => Chip(label: Text(badge)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void showRewardAnimation() {
    _confettiController.play();
  }
}
