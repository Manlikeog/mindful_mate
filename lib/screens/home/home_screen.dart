import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mindful_mate/providers/gamification/gamification_provider.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';
import 'package:mindful_mate/screens/chanllenges/model/chanllenge.dart';
import 'package:mindful_mate/screens/activities/ActivitiesScreen.dart';
import 'package:mindful_mate/screens/chanllenges/chanllenge_screen.dart';
import 'package:mindful_mate/screens/chanllenges/challenge_card.dart';
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
    MoodTrackerScreen(),
    JournalScreen(),
    RelaxationScreen(),
    ProgressScreen()
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
          ['Home', 'Journal', 'Relaxation', 'Progress'][_selectedIndex],
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
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Relaxation'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: 'Progress'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: palette.primaryColor,
        unselectedItemColor: palette.textColor.withOpacity(0.6),
        onTap: _onItemTapped,
      ),
    );
  }
}

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(gamificationProvider);
    final palette = injector.palette;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProgressCard(progress, palette, context),
          const InsightsCard(),
          const ChallengeCard(),
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
      default:
        levelName = 'Legend ${progress.level - 3}';
        break;
    }
    final levelTotalPoints = levelPoints[progress.level] ?? 0;
    final passMark = passMarks[progress.level] ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: MediaQuery.of(context).size.width - 32,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                palette.primaryColor.withOpacity(0.15),
                palette.secondaryColor.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: palette.primaryColor.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Level $levelName',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: palette.textColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [palette.primaryColor, palette.secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: palette.dividerColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: 10,
                    width: levelTotalPoints > 0
                        ? (progress.totalPoints / levelTotalPoints) *
                            (MediaQuery.of(context).size.width - 80)
                        : 0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [palette.primaryColor, palette.accentColor],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level ${progress.level}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: palette.textColor.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '${progress.totalPoints}/$levelTotalPoints',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: palette.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const Gap(12),
              Row(
                children: [
                  Text(
                    'Pass Mark: $passMark',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: palette.textColor.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: palette.accentColor.withOpacity(0.2),
                      border: Border.all(color: palette.accentColor, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${progress.streakCount}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: palette.accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const Gap(4),
                        Text(
                          '🔥',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(20),
              if (progress.badges.isNotEmpty)
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: progress.badges
                          .map((badge) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        palette.secondaryColor,
                                        palette.secondaryColor.withOpacity(0.8)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: palette.secondaryColor
                                            .withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    badge,
                                    style: TextStyle(
                                      color: palette.pureWhite,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: palette.textColor.withOpacity(0.6),
                      size: 20,
                    ),
                    const Gap(8),
                    Text(
                      'No badges yet—keep going! 🌟',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: palette.textColor.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
