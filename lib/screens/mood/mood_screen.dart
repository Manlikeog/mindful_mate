import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mindful_mate/screens/mood/widgets/mood_calendar.dart';
import 'package:mindful_mate/screens/mood/widgets/notification_banner.dart';
import 'package:mindful_mate/screens/mood/widgets/trend_chart.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:confetti/confetti.dart';

class MoodTrackerScreen extends ConsumerStatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  MoodTrackerScreenState createState() => MoodTrackerScreenState();
}

class MoodTrackerScreenState extends ConsumerState<MoodTrackerScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = injector.palette;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
                  const NotificationBanner(),
              const MoodCalendar(),
              const TrendChart(),
              const Gap(16),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            colors: [palette.primaryColor, palette.secondaryColor, palette.accentColor],
          ),
        ),
      ],
    );
  }

  void showRewardAnimation() {
    _confettiController.play();
  }
}