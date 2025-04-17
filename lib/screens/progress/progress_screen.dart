import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mindful_mate/screens/journal/journal_screen.dart';
import 'package:mindful_mate/screens/mood/mood_screen.dart';
import 'package:mindful_mate/screens/progress/widgets/challenge_card.dart';
import 'package:mindful_mate/screens/progress/widgets/insight_card.dart';
import 'package:mindful_mate/screens/progress/widgets/progress_card.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class ProgressScreen extends ConsumerWidget {
  static const String path = 'progress';
  static const String fullPath = '/progress';
  static const String pathName = '/progress';
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = injector.palette;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: palette.primaryColor.withOpacity(0.9),
        title: Text(
          'Your Progress',
          style: TextStyle(
            fontSize: 22.ww(context),
            fontWeight: FontWeight.bold,
            color: palette.pureWhite,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                palette.primaryColor,
                palette.secondaryColor.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              palette.primaryColor.withOpacity(0.2),
              palette.accentColor.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildQuickActionsSection(context, palette),
                const ProgressCard(),
                const InsightsCard(),
                const ChallengeCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, Palette palette) {
    return Container(
      margin: EdgeInsets.all(2.ph(context)),
      padding: EdgeInsets.all(4.pw(context)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.primaryColor.withOpacity(0.1),
            palette.accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(5.pw(context)),
        boxShadow: [
          BoxShadow(
            color: palette.textColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Take Action Now',
            style: TextStyle(
              fontSize: 20.ww(context),
              fontWeight: FontWeight.bold,
              color: palette.textColor,
            ),
          ),
          SizedBox(height: 2.ph(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                palette,
                'Log Mood',
                Icons.mood,
                MoodTrackerScreen.fullPath,
                palette.primaryColor,
              ),
              SizedBox(width: 3.pw(context)),
              _buildActionButton(
                context,
                palette,
                'Write Journal',
                Icons.book,
                JournalScreen.fullPath,
                palette.secondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, Palette palette, String label,
      IconData icon, String route, Color color) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () => context.push(route),
        icon: Icon(icon, size: 18.ww(context), color: palette.pureWhite),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 13.ww(context),
            color: palette.pureWhite,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(
              vertical: 1.5.ph(context), horizontal: 2.pw(context)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.pw(context))),
          elevation: 1,
          shadowColor: color.withOpacity(0.2),
        ),
      ),
    );
  }
}
