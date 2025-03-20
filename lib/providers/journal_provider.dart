import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/repository/database_Helper.dart';

class JournalEntry {
  final DateTime date;
  final String content;
  final int? moodIndex;
  final String title;
  final bool isBold;
  final bool isItalic;

  JournalEntry({
    required this.date,
    required this.content,
    required this.title,
    this.moodIndex,
    this.isBold = false,
    this.isItalic = false,
  });

  Map<String, dynamic> toMap() => {
    'date': date.toIso8601String(),
    'content': content,
    'title': title,
    'moodIndex': moodIndex,
    'isBold': isBold ? 1 : 0,
    'isItalic': isItalic ? 1 : 0,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntry &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          content == other.content &&
          title == other.title;

  @override
  int get hashCode => date.hashCode ^ content.hashCode ^ title.hashCode;
}

class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<JournalEntry> _originalEntries = [];
  String _searchQuery = '';
  bool _sortDescending = true;
  DateTime? _filterDate;

  JournalNotifier() : super([]) {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    _originalEntries = await _dbHelper.getJournalEntries();
    _applyFilters();
  }

  void saveEntry(JournalEntry entry) {
    _originalEntries = [..._originalEntries, entry];
    _dbHelper.saveJournalEntry(entry);
    _applyFilters();
  }

  void updateEntry(JournalEntry oldEntry, JournalEntry newEntry) {
    _originalEntries = _originalEntries.map((e) => e == oldEntry ? newEntry : e).toList();
    _dbHelper.saveJournalEntry(newEntry); // Overwrites due to PRIMARY KEY
    _applyFilters();
  }

  void deleteEntry(JournalEntry entry) {
    _originalEntries = _originalEntries.where((e) => e != entry).toList();
    _dbHelper.deleteJournalEntry(entry);
    _applyFilters();
  }

  void clearEntries() {
    _originalEntries = [];
    _dbHelper.clearJournalEntries();
    state = [];
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

  bool get isSortDescending => _sortDescending;
  DateTime? get filterDate => _filterDate;

  void _applyFilters() {
    List<JournalEntry> filtered = List.from(_originalEntries);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((e) =>
              e.content.toLowerCase().contains(_searchQuery) ||
              e.title.toLowerCase().contains(_searchQuery))
          .toList();
    }

    if (_filterDate != null) {
      filtered = filtered
          .where((e) =>
              e.date.year == _filterDate!.year &&
              e.date.month == _filterDate!.month &&
              e.date.day == _filterDate!.day)
          .toList();
    }

    filtered.sort((a, b) => _sortDescending ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
    state = filtered;
  }
}

final journalProvider = StateNotifierProvider<JournalNotifier, List<JournalEntry>>((ref) => JournalNotifier());
final viewModeProvider = StateProvider<bool>((ref) => false);
final searchQueryProvider = StateProvider<String>((ref) => '');