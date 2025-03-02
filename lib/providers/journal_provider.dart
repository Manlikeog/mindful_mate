// 1. providers/journal_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';


class JournalEntry {
  final DateTime date;
  final String content;
  final int? moodIndex;
  final bool isBold;
  final bool isItalic;

  JournalEntry({
    required this.date,
    required this.content,
    this.moodIndex,
    this.isBold = false,
    this.isItalic = false,
  });
}

class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  JournalNotifier() : super([]);

  void saveEntry(JournalEntry entry) {
    state = [
      ...state.where((e) => e.date != entry.date),
      entry,
    ];
  }
}

final journalProvider = StateNotifierProvider<JournalNotifier, List<JournalEntry>>((ref) => JournalNotifier());
final viewModeProvider = StateProvider<bool>((ref) => false); // false = list, true = grid
final searchQueryProvider = StateProvider<String>((ref) => '');