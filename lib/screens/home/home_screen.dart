import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mindful_mate/providers/gamification/gamification_provider.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';
import 'package:mindful_mate/screens/activities/ActivitiesScreen.dart';
import 'package:mindful_mate/screens/chanllenges/chanllenge_screen.dart';
import 'package:mindful_mate/screens/journal/journal_screen.dart';
import 'package:mindful_mate/screens/mood/mood_screen.dart';
import 'package:mindful_mate/screens/profile/profile_screen.dart';
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/screens/mood/model/insight_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String path = 'home';
  static const String fullPath = '/home';
  static const String pathName = '/home';
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeContent(), // Home tab content
    JournalScreen(),
    MoodTrackerScreen(),
    ActivitiesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = injector.palette;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: palette.pureWhite,
        title: Text(
          [
            'Home',
            'Journal',
            'Mood Tracker',
            'Activities',
            'Profile'
          ][_selectedIndex],
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: palette.textColor),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Tracker'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: 'Activities'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: palette.primaryColor,
        unselectedItemColor: palette.textColor.withOpacity(0.6),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(gamificationProvider);
    final palette = injector.palette;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProgressCard(progress, palette, context),
          const InsightsCard(),
          const Gap(16),
          ElevatedButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => ChallengesScreen())),
            child: const Text('View Challenges'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => RelaxationScreen())),
            child: const Text('Relaxation Exercises'),
          ),
          const Gap(16),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
      UserProgress progress, Palette palette, BuildContext context) {
    String levelName;
    switch (progress.level) {
      case 1:
        levelName = 'Beginner';
        break;
      case 2:
        levelName = 'Explorer';
        break;
      case 3:
        levelName = 'Champion';
        break;
      case 4:
        levelName = 'Master';
        break;
      default:
        levelName = 'Legend ${progress.level - 4}';
        break;
    }

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
                'Level $levelName (${progress.level}) | Streak: ${progress.streakCount} days'),
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
}
