import 'package:go_router/go_router.dart';
import 'package:mindful_mate/screens/home/home_screen.dart';
import 'package:mindful_mate/screens/journal/journal_screen.dart';
import 'package:mindful_mate/screens/mood/mood_screen.dart';
import 'package:mindful_mate/screens/onboarding/onboarding_screen.dart';
import 'package:mindful_mate/screens/onboarding/splash_screen.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/transition.dart';

final router = GoRouter(
  initialLocation: '/app', // Set initial route directly instead of using redirect
  routes: [
     GoRoute(
      path: '/app', // Handle '/app' directly without redirection
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const SplashScreen(),
      ),
    ),
    GoRoute(
      path: '/onboarding', // Full path for onboarding screen
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const OnboardingScreen(),
      ),
    ),
    GoRoute(
      path: '/home', // Full path for onboarding screen
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const HomeScreen(),
      ),
    ),
     GoRoute(
      path: '/moodTracker', // Full path for onboarding screen
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const MoodTrackerScreen(),
      ),
    ),
    GoRoute(
      path: '/journal', // Full path for onboarding screen
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: JournalScreen()
      ),
    ),
  ],
);
