import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful_mate/screens/journal/journal_screen.dart';
import 'package:mindful_mate/screens/mood/mood_screen.dart';
import 'package:mindful_mate/screens/progress/progress_screen.dart';
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class HomeScreen extends StatelessWidget {
  static const String path = 'home';
  static const String fullPath = '/home';
  static const String pathName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = injector.palette;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              palette.primaryColor.withOpacity(0.3),
              palette.accentColor.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: 5.pw(context), vertical: 3.ph(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 4.ph(context)),
                Text(
                  'Welcome to Mindful Mate',
                  style: TextStyle(
                    fontSize: 28.ww(context),
                    fontWeight: FontWeight.bold,
                    color: palette.textColor,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.ph(context)),
                Text(
                  'Your journey to mindfulness starts here',
                  style: TextStyle(
                    fontSize: 16.ww(context),
                    color: palette.textColor.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5.ph(context)),
                _buildFeatureCard(
                  context,
                  palette,
                  'Mood Tracking',
                  'Log your daily mood with ease to earn 2 points and understand your emotions.',
                  Icons.mood,
                  MoodTrackerScreen.fullPath,
                  palette.primaryColor,
                ),
                SizedBox(height: 3.ph(context)),
                _buildFeatureCard(
                  context,
                  palette,
                  'Journaling',
                  'Capture your thoughts with guided prompts to earn 3 points and find clarity.',
                  Icons.book,
                  JournalScreen.fullPath,
                  palette.secondaryColor,
                ),
                SizedBox(height: 3.ph(context)),
                _buildFeatureCard(
                  context,
                  palette,
                  'Relaxation',
                  'Unwind with guided exercises to earn 2 points and restore your calm.',
                  Icons.self_improvement,
                  RelaxationScreen.fullPath,
                  palette.accentColor,
                ),
                SizedBox(height: 3.ph(context)),
                _buildFeatureCard(
                  context,
                  palette,
                  'Challenges',
                  'Complete daily challenges to earn points and grow your mindfulness.',
                  Icons.fitness_center,
                  ProgressScreen.fullPath,
                  palette.primaryColor,
                ),
                SizedBox(height: 4.ph(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, Palette palette, String title,
      String description, IconData icon, String route, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.pw(context))),
      child: Padding(
        padding: EdgeInsets.all(4.pw(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24.ww(context), color: color),
                SizedBox(width: 3.pw(context)),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.ww(context),
                    fontWeight: FontWeight.bold,
                    color: palette.textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.ph(context)),
            Text(
              description,
              style: TextStyle(
                fontSize: 14.ww(context),
                color: palette.textColor.withOpacity(0.85),
                height: 1.4,
              ),
            ),
            SizedBox(height: 3.ph(context)),
            ElevatedButton(
              onPressed: () => context.push(route),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: EdgeInsets.symmetric(
                    horizontal: 4.pw(context), vertical: 2.ph(context)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.pw(context))),
                minimumSize: Size(double.infinity, 10.ph(context)),
                elevation: 2,
              ),
              child: Text(
                'Start $title',
                style: TextStyle(
                  fontSize: 16.ww(context),
                  color: palette.pureWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
