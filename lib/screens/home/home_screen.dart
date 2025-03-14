// 3. screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mindful_mate/providers/home/mood_provider.dart';
import 'package:mindful_mate/providers/home/streak_provider.dart';
import 'package:mindful_mate/providers/system_setup/greeting_provider.dart';
import 'package:mindful_mate/utils/app_widget/particle_background.dart';


class HomeScreen extends ConsumerWidget {
  static const String path = 'home';
  static const String fullPath = '/home';
  static const String pathName = '/home';

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(greetingProvider);
    final streakState = ref.watch(streakProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background with Particles
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2AB7CA), Color(0xFF9B5DE5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AnimatedParticles(),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Greeting Header
                _GreetingHeader(greeting: greeting, context: context),
                
                // Mood Logging Card
                _MoodLoggingCard(),
                
                // Streak Counter
                _StreakCounter(streak: streakState.streak),
                
                // Journal Prompt Card
                _JournalPromptCard(),
              ],
            ),
          ),

          // Celebration Animation
          if (streakState.showCelebration)
            IgnorePointer(
              child: Center(
                child: Lottie.asset(
                  'assets/animations/confetti.json',
                  repeat: false,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }

  Widget _GreetingHeader({required String greeting, required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, User! ${_getTimeEmoji()}',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  String _getTimeEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '🌙';
    if (hour < 12) return '🌞';
    if (hour < 18) return '🌤';
    return '🌜';
  }

  Widget _MoodLoggingCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('How are you today?', 
              style: TextStyle(fontSize: 18, color: Colors.grey[800])),
            SizedBox(height: 12),
            _EmojiSlider(),
          ],
        ),
      ),
    );
  }

  Widget _EmojiSlider() {
    final emojis = ['😢', '😐', '😊', '😄', '🌟'];
    
    return Consumer(
      builder: (context, ref, child) {
        final selectedMood = ref.watch(moodProvider);
        return SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: emojis.length,
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (ctx, index) => GestureDetector(
              // onTap: () => ref.read(moodProvider.notifier).logMood(index, DateTime.now()),
              child: AnimatedScale(
                scale: selectedMood == index ? 1.2 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Text(
                  emojis[index],
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _StreakCounter({required int streak}) {
    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: streak / 7,
                color: Color(0xFFFFD166),
                strokeWidth: 8,
                backgroundColor: Colors.grey[200],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.whatshot, color: Colors.orange, size: 28),
                  SizedBox(height: 4),
                  Text('$streak-Day\nStreak', 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _JournalPromptCard() {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text("What made you smile today?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: FloatingActionButton.small(
          backgroundColor: Color(0xFF9B5DE5),
          child: Icon(Icons.edit, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _BottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        _NavItem(Icons.home_outlined, Icons.home, 'Home'),
        _NavItem(Icons.book_outlined, Icons.book, 'Journal'),
        _NavItem(Icons.spa_outlined, Icons.spa, 'Activities'),
        _NavItem(Icons.person_outlined, Icons.person, 'Profile'),
      ],
      currentIndex: 0,
      selectedItemColor: Color(0xFF2AB7CA),
      unselectedItemColor: Colors.grey,
    );
  }

  BottomNavigationBarItem _NavItem(IconData icon, IconData activeIcon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Icon(activeIcon),
      label: label,
    );
  }
}