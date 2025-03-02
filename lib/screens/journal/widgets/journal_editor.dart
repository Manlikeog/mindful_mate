// 2. widgets/journal_editor.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/journal_provider.dart';
import 'package:intl/intl.dart';

class JournalEditor extends ConsumerStatefulWidget {
  final String prompt;

  const JournalEditor({required this.prompt});

  @override
  _JournalEditorState createState() => _JournalEditorState();
}

class _JournalEditorState extends ConsumerState<JournalEditor> {
  final _controller = TextEditingController();
  bool _isBold = false;
  bool _isItalic = false;
  DateTime _lastSave = DateTime.now();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveEntry() {
    ref.read(journalProvider.notifier).saveEntry(
      JournalEntry(
        date: DateTime.now(),
        content: _controller.text,
        isBold: _isBold,
        isItalic: _isItalic,
      ),
    );
    setState(() => _lastSave = DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Formatting Controls
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.format_bold, color: _isBold ? Color(0xFF9B5DE5) : Colors.grey),
              onPressed: () => setState(() => _isBold = !_isBold),
            ),
            IconButton(
              icon: Icon(Icons.format_italic, color: _isItalic ? Color(0xFF9B5DE5) : Colors.grey),
              onPressed: () => setState(() => _isItalic = !_isItalic),
            ),
            Spacer(),
            Text(
              'Saved ${DateFormat('HH:mm').format(_lastSave)}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        // Text Field
        Expanded(
          child: TextField(
            controller: _controller,
            maxLines: null,
            style: TextStyle(
              fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
              fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Start writing...',
              border: InputBorder.none,
            ),
            onChanged: (_) => _saveEntry(),
          ),
        ),
      ],
    );
  }
}