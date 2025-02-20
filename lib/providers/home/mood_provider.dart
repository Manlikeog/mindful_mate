import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoodNotifier extends StateNotifier<Map<DateTime, int>> {
  MoodNotifier() : super({});

  void logMood(int index, DateTime datetime) {
    state = {
      ...state,
      datetime : index
    };
    HapticFeedback.lightImpact();
  }
}

final moodProvider = StateNotifierProvider<MoodNotifier, Map<DateTime, int>>((ref) => MoodNotifier());


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