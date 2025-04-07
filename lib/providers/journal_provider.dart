import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/controller/journal_controller.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/providers/data_provider.dart';
import 'package:mindful_mate/providers/gamification_provider.dart';

final journalControllerProvider = Provider((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return JournalController(dbHelper);
});

final journalProvider = StateNotifierProvider<JournalNotifier, List<JournalEntry>>((ref) {
  return JournalNotifier(ref);
});

class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  final Ref ref;
  String _searchQuery = '';
  bool _sortDescending = true;
  DateTime? _filterDate;

  bool get isSortDescending => _sortDescending;
  DateTime? get filterDate => _filterDate;

  JournalNotifier(this.ref) : super([]) {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final controller = ref.read(journalControllerProvider);
    try {
      final entries = await controller.fetchJournalEntries();
      state = entries;
    } catch (e) {
      print('Initial journal load failed: $e');
    }
  }

  Future<void> saveEntry(BuildContext context, JournalEntry entry) async {
    final controller = ref.read(journalControllerProvider);
    final progress = ref.read(gamificationProvider);
    await controller.saveJournalEntry(
      context,
      entry,
      progress: progress,
      onFeedback: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: message.contains('booster') ? Colors.green : Colors.grey,
          ),
        );
      },
    );
    state = List.from([...state.where((e) => e.id != entry.id), entry]);
    if (_filterDate == null || controller.isSameDay(_filterDate!, entry.date)) {
    await _applyFilters();
        ref.read(gamificationProvider.notifier).refresh();
  }
  }

  Future<void> deleteEntry(String id) async {
    final controller = ref.read(journalControllerProvider);
    await controller.deleteJournalEntry(id);
    state = state.where((e) => e.id != id).toList();
    await _applyFilters();
  }

  Future<void> updateEntry(BuildContext context, JournalEntry oldEntry, JournalEntry newEntry) async {
    final controller = ref.read(journalControllerProvider);
    final progress = ref.read(gamificationProvider);
    state = state.map((e) => e == oldEntry ? newEntry : e).toList();
    await controller.saveJournalEntry(
      context,
      newEntry,
      progress: progress,
      onFeedback: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: message.contains('booster') ? Colors.green : Colors.grey,
          ),
        );
      },
    );
    await _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void toggleSortOrder() {
    _sortDescending = !_sortDescending;
    _applyFilters();
  }

  void setFilterDate(DateTime? date) {
    _filterDate = date;
    _applyFilters();
  }

  Future<void> _applyFilters() async {
    var filtered = state;
    final controller = ref.read(journalControllerProvider);

    if (_searchQuery.isNotEmpty) {
      filtered = controller.filterEntriesBySearchQuery(filtered, _searchQuery);
    }
    if (_filterDate != null) {
      filtered = controller.filterEntriesByDate(filtered, _filterDate!);
    }
    filtered = controller.sortEntries(filtered, _sortDescending);
    state = filtered;
  }
}

final viewModeProvider = StateProvider<bool>((ref) => false);
final searchQueryProvider = StateProvider<String>((ref) => '');