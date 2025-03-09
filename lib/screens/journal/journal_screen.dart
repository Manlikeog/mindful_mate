// 3. screens/journal_screen.dart
import 'dart:async';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/journal_provider.dart';
import 'package:mindful_mate/screens/journal/widgets/journal_editor.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/constants.dart';

class JournalScreen extends ConsumerStatefulWidget {
  static const String path = 'journal';
  static const String fullPath = '/journal';
  static const String pathName = '/journal';

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(journalProvider);
    final viewMode = ref.watch(viewModeProvider);
    final journalNotifier = ref.watch(journalProvider.notifier);
    final currentPrompt = "Recall a time when you experienced a sense of pride";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: injector.palette.pureWhite,
        title: _buildSearchField(ref),
        actions: [
          IconButton(
            icon: Icon(
              journalNotifier.isSortDescending
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: injector.palette.primaryColor,
            ),
            onPressed: () =>
                ref.read(journalProvider.notifier).toggleSortOrder(),
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: injector.palette.primaryColor,
            ),
            onPressed: () => _showFilterDialog(context, ref),
          ),
          IconButton(
            icon: Icon(
              viewMode ? Icons.list : Icons.grid_view,
              color: injector.palette.primaryColor,
            ),
            onPressed: () =>
                ref.read(viewModeProvider.notifier).state = !viewMode,
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildPromptBackground(currentPrompt, context),
          if (entries.isNotEmpty)
            Positioned.fill(
              child: IgnorePointer(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                      color: injector.palette.lightGray.withOpacity(0.1)),
                ),
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                if (journalNotifier.filterDate != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Filtered by: ${DateFormat('MMM dd, yyyy').format(journalNotifier.filterDate!)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color:
                                    injector.palette.textColor.withOpacity(0.7),
                              ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 20,
                            color: injector.palette.textColor.withOpacity(0.7),
                          ),
                          onPressed: () => ref
                              .read(journalProvider.notifier)
                              .setFilterDate(null),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: viewMode
                      ? _buildGridView(entries, ref)
                      : _buildListView(entries, ref),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: injector.palette.secondaryColor,
        foregroundColor: injector.palette.pureWhite,
        elevation: 6,
        child: Icon(Icons.add, size: 28),
        onPressed: () => _showPromptDialog(context, ref, null),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  Widget _buildSearchField(WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search entries...',
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: injector.palette.textColor.withOpacity(0.5),
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: injector.palette.dividerColor),
        ),
        filled: true,
        fillColor: injector.palette.textFieldColorLightMode,
        prefixIcon: Icon(Icons.search, color: injector.palette.primaryColor),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: (value) {
        ref.read(searchQueryProvider.notifier).state = value;
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(Duration(milliseconds: 300), () {
          ref.read(journalProvider.notifier).setSearchQuery(value);
        });
      },
    );
  }

  Widget _buildPromptBackground(String prompt, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(80),
      color: injector.palette.lightGray,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Start Journaling",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: injector.palette.primaryColor,
                ),
          ),
          SizedBox(height: 8),
          Text(
            prompt,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: injector.palette.textColor.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<JournalEntry> entries, WidgetRef ref) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (ctx, i) => _buildEntryCard(entries[i], ctx, ref),
    );
  }

  Widget _buildGridView(List<JournalEntry> entries, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85, // Adjusted for better card appearance
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      padding: EdgeInsets.all(8),
      itemCount: entries.length,
      itemBuilder: (ctx, i) => _buildEntryCard(entries[i], ctx, ref),
    );
  }

  Widget _buildEntryCard(
      JournalEntry entry, BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: injector.palette.pureWhite,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (entry.moodIndex != null)
                      Text(
                        ['😢', '😐', '😊', '😄', '🌟'][entry.moodIndex!],
                        style: TextStyle(fontSize: 20),
                      ),
                    SizedBox(width: 8),
                    Text(
                      DateFormat('MMM dd').format(entry.date),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: injector.palette.textColor.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit,
                          size: 20, color: injector.palette.secondaryColor),
                      onPressed: () => _showPromptDialog(context, ref, entry),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete,
                          size: 20, color: injector.palette.accentColor),
                      onPressed: () => _confirmDelete(context, ref, entry),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            if (entry.title != null && entry.title!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  entry.title!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: injector.palette.textColor,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Text(
              entry.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: entry.isBold ? FontWeight.bold : null,
                    fontStyle: entry.isItalic ? FontStyle.italic : null,
                    color: injector.palette.textColor.withOpacity(0.85),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPromptDialog(
      BuildContext context, WidgetRef ref, JournalEntry? entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: injector.palette.pureWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: JournalEditor(
            prompt: entry == null ? "Describe a moment you felt proud" : "",
            entry: entry,
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, JournalEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:
            Text('Delete Entry', style: Theme.of(context).textTheme.titleLarge),
        content: Text(
          'Are you sure you want to delete this journal entry?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(color: injector.palette.textColor)),
          ),
          TextButton(
            onPressed: () {
              ref.read(journalProvider.notifier).deleteEntry(entry);
              Navigator.pop(ctx);
            },
            child: Text('Delete',
                style: TextStyle(color: injector.palette.accentColor)),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Filter by Date',
            style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: injector.palette.primaryColor,
                foregroundColor: injector.palette.pureWhite,
              ),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: injector.palette.primaryColor,
                          onPrimary: injector.palette.pureWhite,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  ref.read(journalProvider.notifier).setFilterDate(picked);
                  Navigator.pop(ctx);
                }
              },
              child: Text('Select Date'),
            ),
            TextButton(
              onPressed: () {
                ref.read(journalProvider.notifier).setFilterDate(null);
                Navigator.pop(ctx);
              },
              child: Text('Clear Filter',
                  style: TextStyle(color: injector.palette.textColor)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close',
                style: TextStyle(color: injector.palette.textColor)),
          ),
        ],
      ),
    );
  }
}
