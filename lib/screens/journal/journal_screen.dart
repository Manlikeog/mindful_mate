// 3. screens/journal_screen.dart
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/journal_provider.dart';
import 'package:mindful_mate/screens/journal/widgets/journal_editor.dart';

class JournalScreen extends ConsumerWidget {
  static const String path = 'journal';
  static const String fullPath = '/journal';
  static const String pathName = '/journal';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(journalProvider);
    final viewMode = ref.watch(viewModeProvider);
    final currentPrompt =
        "Describe a moment you felt proud"; // Replace with prompt provider

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(ref),
        actions: [
          IconButton(
            icon: Icon(viewMode ? Icons.list : Icons.grid_view),
            onPressed: () =>
                ref.read(viewModeProvider.notifier).state = !viewMode,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Blurred Prompt Background
          _buildPromptBackground(currentPrompt),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: viewMode
                      ? _buildGridView(entries)
                      : _buildListView(entries),
                ),
                _buildCustomPromptButton(),
              ],
            ),
          ),

          // Editor Overlay
          // if (currentPrompt.isNotEmpty)
          //   Positioned.fill(
          //     child: IgnorePointer(
          //       child: BackdropFilter(
          //         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          //         child: Container(color: Colors.white.withOpacity(0.1)),
          //       ),
          //     ),
          //   ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF2AB7CA),
        child: Icon(Icons.add),
        onPressed: () => _showPromptDialog(context, ref),
      ),
    );
  }

  Widget _buildSearchField(WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search entries...',
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) =>
          ref.read(searchQueryProvider.notifier).state = value,
    );
  }

  Widget _buildPromptBackground(String prompt) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(32),
      child: Text(
        prompt,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildListView(List<JournalEntry> entries) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (ctx, i) => _buildEntryCard(entries[i]),
    );
  }

  Widget _buildGridView(List<JournalEntry> entries) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
      ),
      itemCount: entries.length,
      itemBuilder: (ctx, i) => _buildEntryCard(entries[i]),
    );
  }

  Widget _buildEntryCard(JournalEntry entry) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (entry.moodIndex != null)
                  Text(['😢', '😐', '😊', '😄', '🌟'][entry.moodIndex!]),
                SizedBox(width: 8),
                Text(DateFormat('MMM dd').format(entry.date)),
              ],
            ),
            SizedBox(height: 8),
            Text(
              entry.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: entry.isBold ? FontWeight.bold : null,
                fontStyle: entry.isItalic ? FontStyle.italic : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomPromptButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add_circle),
        label: Text('Custom Prompt'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9B5DE5),
        ),
        onPressed: () {}, // Implement custom prompt dialog
      ),
    );
  }

  void _showPromptDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: JournalEditor(prompt: "Describe a moment you felt proud"),
        ),
      ),
    );
  }
}
