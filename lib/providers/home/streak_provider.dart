import 'package:hooks_riverpod/hooks_riverpod.dart';

class StreakState {
  final int streak;
  final bool showCelebration;

  StreakState({required this.streak, this.showCelebration = false});

  StreakState copyWith({int? streak, bool? showCelebration}) {
    return StreakState(
      streak: streak ?? this.streak,
      showCelebration: showCelebration ?? this.showCelebration
    );
  }
}

class StreakNotifier extends StateNotifier<StreakState> {
  StreakNotifier() : super(StreakState(streak: 3));

  void incrementStreak() {
    state = state.copyWith(
      streak: state.streak + 1,
      showCelebration: true
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      state = state.copyWith(showCelebration: false);
    });
  }
}

final streakProvider = StateNotifierProvider<StreakNotifier, StreakState>((ref) => StreakNotifier());