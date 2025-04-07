import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindful_mate/screens/progress/progress_screen.dart';
import 'package:mindful_mate/screens/journal/journal_screen.dart';
import 'package:mindful_mate/screens/mood/mood_screen.dart';
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';


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

