import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/providers/journal_provider.dart';
import 'package:mindful_mate/screens/journal/widgets/journal_card.dart';
import 'package:mindful_mate/screens/journal/widgets/journal_editor.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class JournalScreen extends ConsumerStatefulWidget {
    static const String path = 'journal';
  static const String pathName = 'journal';
  static const String fullPath = '/journal';


  const JournalScreen({super.key});

  @override
  JournalScreenState createState() => JournalScreenState();
}

class JournalScreenState extends ConsumerState<JournalScreen> {
  Timer? _debounce;
  static const _currentPrompt =
      "Recall a time when you experienced a sense of pride";

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = injector.palette;
    final entries = ref.watch(journalProvider);
    final viewMode = ref.watch(viewModeProvider);
    final journalNotifier = ref.read(journalProvider.notifier);

    return Scaffold(
      appBar: _buildAppBar(context, journalNotifier, palette),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: 2.pw(context), vertical: 2.ph(context)),
          child: Stack(
            children: [
              _buildPromptBackground(context),
              if (entries.isNotEmpty)
                Positioned.fill(
                  child: IgnorePointer(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child:
                          Container(color: palette.lightGray.withOpacity(0.1)),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (journalNotifier.filterDate != null)
                    _buildFilterInfo(
                        context, journalNotifier.filterDate!, palette),
                  viewMode ? _buildGridView(entries) : _buildListView(entries),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(context, palette),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  AppBar _buildAppBar(
      BuildContext context, JournalNotifier journalNotifier, Palette palette) {
    return AppBar(
      elevation: 0,
      backgroundColor: palette.pureWhite,
      title: _buildSearchField(context),
      actions: [
        IconButton(
          icon: Icon(
            journalNotifier.isSortDescending
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color: palette.primaryColor,
            size: 20.ww(context),
          ),
          onPressed: () async =>
              await ref.read(journalProvider.notifier).toggleSortOrder(),
        ),
        IconButton(
          icon: Icon(Icons.filter_list,
              color: palette.primaryColor, size: 20.ww(context)),
          onPressed: () async => await _showFilterDialog(context),
        ),
        IconButton(
          icon: Icon(
            ref.watch(viewModeProvider) ? Icons.list : Icons.grid_view,
            color: palette.primaryColor,
            size: 20.ww(context),
          ),
          onPressed: () => ref.read(viewModeProvider.notifier).state =
              !ref.read(viewModeProvider),
        ),
      ],
      flexibleSpace: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.pw(context)),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final palette = injector.palette;
    return Container(
      constraints: BoxConstraints(maxWidth: 80.pw(context)),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search entries...',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.textColor.withOpacity(0.5),
                fontSize: 14.ww(context),
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.pw(context)),
            borderSide: BorderSide(color: palette.dividerColor),
          ),
          filled: true,
          fillColor: palette.textFieldColorLightMode,
          prefixIcon: Icon(Icons.search,
              color: palette.primaryColor, size: 20.ww(context)),
          contentPadding: EdgeInsets.symmetric(vertical: 1.ph(context)),
        ),
        style: TextStyle(fontSize: 16.ww(context)),
        onChanged: (value) async {
          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 300), () async {
            await ref.read(journalProvider.notifier).setSearchQuery(value);
          });
        },
      ),
    );
  }

  Widget _buildPromptBackground(BuildContext context) {
    final palette = injector.palette;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20.pw(context)),
      color: palette.lightGray,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Start Journaling",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: palette.primaryColor,
                  fontSize: 24.ww(context),
                ),
          ),
          SizedBox(height: 2.ph(context)),
          Text(
            _currentPrompt,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: palette.textColor.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                  fontSize: 16.ww(context),
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterInfo(
      BuildContext context, DateTime filterDate, Palette palette) {
    return Padding(
      padding: EdgeInsets.all(2.pw(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Filtered by: ${DateFormat('MMM dd, yyyy').format(filterDate)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.textColor.withOpacity(0.7),
                  fontSize: 14.ww(context),
                ),
          ),
          SizedBox(width: 2.pw(context)),
          IconButton(
            icon: Icon(
              Icons.clear,
              size: 20.ww(context),
              color: palette.textColor.withOpacity(0.7),
            ),
            onPressed: () async =>
                await ref.read(journalProvider.notifier).setFilterDate(null),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<JournalEntry> entries) {
    return Column(
      children: entries.map((entry) => _buildCard(entry)).toList(),
    );
  }

  Widget _buildGridView(List<JournalEntry> entries) {
    return GridView.builder(
      shrinkWrap: true, // Let grid take only needed space
      physics:
          const NeverScrollableScrollPhysics(), // Disable grid's own scrolling
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 2.pw(context),
        mainAxisSpacing: 2.ph(context),
      ),
      padding: EdgeInsets.all(2.pw(context)),
      itemCount: entries.length,
      itemBuilder: (context, index) => _buildCard(entries[index]),
    );
  }

  Widget _buildCard(JournalEntry entry) {
    return JournalCard(
      entry: entry,
      onEdit: () => _showPromptDialog(context, entry),
      onDelete: () => _confirmDelete(context, entry),
    );
  }

  FloatingActionButton _buildFAB(BuildContext context, Palette palette) {
    return FloatingActionButton(
      backgroundColor: palette.secondaryColor,
      foregroundColor: palette.pureWhite,
      elevation: 6,
      child: Icon(Icons.add, size: 28.ww(context)),
      onPressed: () => _showPromptDialog(context, null),
    );
  }

  void _showPromptDialog(BuildContext context, JournalEntry? entry) {
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
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(5.pw(context))),
          ),
          child: JournalEditor(entry: entry),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, JournalEntry entry) {
    final palette = injector.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Entry', style: TextStyle(fontSize: 18.ww(context))),
        content: Text(
          'Are you sure you want to delete this journal entry?',
          style: TextStyle(fontSize: 14.ww(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(
                    color: palette.textColor, fontSize: 14.ww(context))),
          ),
          TextButton(
            onPressed: () {
              ref.read(journalProvider.notifier).deleteEntry(entry.id);
              Navigator.pop(ctx);
            },
            child: Text('Delete',
                style: TextStyle(
                    color: palette.accentColor, fontSize: 14.ww(context))),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterDialog(BuildContext context) async {
    final palette = injector.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:
            Text('Filter by Date', style: TextStyle(fontSize: 18.ww(context))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primaryColor,
                foregroundColor: palette.pureWhite,
                padding: EdgeInsets.symmetric(
                    horizontal: 4.pw(context), vertical: 2.ph(context)),
                textStyle: TextStyle(fontSize: 14.ww(context)),
              ),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: palette.primaryColor,
                        onPrimary: palette.pureWhite,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) {
                  await ref
                      .read(journalProvider.notifier)
                      .setFilterDate(picked);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Select Date'),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(journalProvider.notifier).setFilterDate(null);
                Navigator.pop(ctx);
              },
              child: Text('Clear Filter',
                  style: TextStyle(
                      color: palette.textColor, fontSize: 14.ww(context))),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close',
                style: TextStyle(
                    color: palette.textColor, fontSize: 14.ww(context))),
          ),
        ],
      ),
    );
  }
}
