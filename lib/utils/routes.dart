import 'package:go_router/go_router.dart';
import 'package:mindful_mate/screens/chanllenges/chanllenge_screen.dart';
import 'package:mindful_mate/screens/home/home_screen.dart';
import 'package:mindful_mate/screens/journal/journal_screen.dart';
import 'package:mindful_mate/screens/mood/mood_screen.dart';
import 'package:mindful_mate/screens/onboarding/onboarding_screen.dart';
import 'package:mindful_mate/screens/onboarding/splash_screen.dart';
import 'package:mindful_mate/screens/progress/progress_screen.dart';
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/transition.dart';

final router = GoRouter(
  initialLocation: '/app',
  routes: [
    GoRoute(
      path: '/app',
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const SplashScreen(),
      ),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const OnboardingScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/moodTracker',
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const MoodTrackerScreen(),
      ),
    ),
    GoRoute(
      path: '/progress',
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const ProgressScreen(),
      ),
    ),
    GoRoute(
      path: '/journal',
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const JournalScreen(),
      ),
    ),
    GoRoute(
      path: '/challenges',
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const ChallengesScreen(),
      ),
    ),
    GoRoute(
      path: '/relaxation',
      pageBuilder: (context, state) => buildMyTransition<void>(
        color: injector.palette.primaryColor,
        child: const RelaxationScreen(),
      ),
    ),
  ],
);
