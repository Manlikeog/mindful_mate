import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/data/model/mood/mood_entry.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';
import 'package:mindful_mate/utils/routes.dart';
import 'package:mindful_mate/utils/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(UserProgressAdapter());
  Hive.registerAdapter(ChallengeAdapter());
  Hive.registerAdapter(MoodEntryAdapter());
  Hive.registerAdapter(RelaxationAdapter());
  await Hive.openBox<JournalEntry>('journals');
  await Hive.openBox<UserProgress>('user_progress');
  await Hive.openBox<MoodEntry>('moods');
  await Hive.openBox<Challenge>('challenges');
  await Hive.openBox<Relaxation>('relaxations');
  // MobileAds.instance.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MindfulMate',

    
      theme: MindfulMateThemeData.lightMode,
      darkTheme: MindfulMateThemeData.darkMode,
      routerConfig: router,

      debugShowCheckedModeBanner: false,
    );
  }
}
