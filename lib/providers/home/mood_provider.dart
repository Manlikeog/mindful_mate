import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/screens/mood/model/mood_entry.dart';

class MoodNotifier extends StateNotifier<Map<DateTime, MoodEntry>> {
  MoodNotifier() : super({});

  void logMood(MoodEntry entry) {
    state = {...state, entry.date: entry};
    HapticFeedback.lightImpact();
  }
}

final moodProvider = StateNotifierProvider<MoodNotifier, Map<DateTime, MoodEntry>>((ref) => MoodNotifier());
// final moodProvider = StateNotifierProvider<MoodNotifier, Map<DateTime, int>>(
//     (ref) => MoodNotifier());


// import 'package:flutter/services.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class MoodNotifier extends StateNotifier<int?> {
//   MoodNotifier() : super(null);

//   void logMood(int index) {
//     state = index;
//     HapticFeedback.lightImpact();
//   }
// }

// final moodProvider = StateNotifierProvider<MoodNotifier, int?>((ref) => MoodNotifier());