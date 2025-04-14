import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/controller/journal_controller.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/providers/progress_provider.dart';
import 'package:mindful_mate/utils/date_utils.dart';
import 'package:mindful_mate/utils/error_logger.dart';

/// Provides access to the journal controller.
final journalControllerProvider = Provider((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return JournalController(dbHelper, ref);
});

/// Manages the state of journal entries.
final journalProvider =
    StateNotifierProvider<JournalNotifier, List<JournalEntry>>((ref) {
  return JournalNotifier(ref);
});

/// Notifier for managing journal entries with filtering and sorting.
class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  final Ref providerRef;
  String _searchQuery = '';
  bool _sortDescending = true;
  DateTime? _filterDate;

  bool get isSortDescending => _sortDescending;
  DateTime? get filterDate => _filterDate;

  JournalNotifier(this.providerRef) : super([]) {
    _loadEntries();
  }

  /// Loads all journal entries from the database.
  Future<void> _loadEntries() async {
    final controller = providerRef.read(journalControllerProvider);
    try {
      final entries = await controller.fetchJournalEntries();
      state = entries;
      await _applyFilters();
    } catch (e) {
       ErrorLogger.logError('Initial journal load failed: $e',);
    }
  }

  /// Saves a journal entry and updates state.
  Future<void> saveEntry(BuildContext context, JournalEntry entry) async {
    final controller = providerRef.read(journalControllerProvider);
    final progress = providerRef.read(userProgressProvider);
    await controller.saveJournalEntry(
      context,
      entry,
      progress: progress,
      onFeedback: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor:
                message.contains('no') ? Colors.black : Colors.green,
          ),
        );
      },
    );
    state = List.from([...state.where((e) => e.id != entry.id), entry]);
    if (_filterDate == null || isSameDay(_filterDate!, entry.date)) {
      await _applyFilters();
      providerRef.read(userProgressProvider.notifier).refresh();
    }
  }

  /// Deletes a journal entry by ID.
  Future<void> deleteEntry(String id) async {
    final controller = providerRef.read(journalControllerProvider);
    await controller.deleteJournalEntry(id);
    state = state.where((e) => e.id != id).toList();
    await _applyFilters();
  }

  /// Updates an existing journal entry.
  Future<void> updateEntry(
    BuildContext context,
    JournalEntry oldEntry,
    JournalEntry newEntry,
  ) async {
    final controller = providerRef.read(journalControllerProvider);
    final progress = providerRef.read(userProgressProvider);
    state = state.map((e) => e == oldEntry ? newEntry : e).toList();
    await controller.saveJournalEntry(
      context,
      newEntry,
      progress: progress,
      onFeedback: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor:
                message.contains('no') ? Colors.black : Colors.green,
          ),
        );
      },
    );
    await _applyFilters();
  }

  /// Sets the search query and applies filters.
  Future<void> setSearchQuery(String query) async {
    _searchQuery = query.toLowerCase();
     ErrorLogger.logError('Search query updated: $_searchQuery');
    await _applyFilters();
  }

  /// Toggles the sort order and applies filters.
  Future<void> toggleSortOrder() async {
    _sortDescending = !_sortDescending;
     ErrorLogger.logError('Sort order toggled: descending=$_sortDescending');
    await _applyFilters();
  }

  /// Sets the filter date and applies filters.
  Future<void> setFilterDate(DateTime? date) async {
    _filterDate = date;
     ErrorLogger.logError('Filter date set: $_filterDate');
    await _applyFilters();
  }

  /// Applies search, date, and sort filters to entries.
  Future<void> _applyFilters() async {
    final controller = providerRef.read(journalControllerProvider);
    var filtered = List<JournalEntry>.from(state);

    if (_searchQuery.isNotEmpty) {
      filtered = await controller.filterEntriesBySearchQuery(filtered, _searchQuery);
    }
    if (_filterDate != null) {
      filtered = await controller.filterEntriesByDate(filtered, _filterDate!);
    }
    filtered = controller.sortEntries(filtered, _sortDescending);
    state = List.from(filtered);
  }
}

final viewModeProvider = StateProvider<bool>((ref) => false);
final searchQueryProvider = StateProvider<String>((ref) => '');