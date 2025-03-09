// 2. widgets/journal_editor.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful_mate/providers/journal_provider.dart';
import 'package:intl/intl.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/extension/widget_extension.dart';

class JournalEditor extends ConsumerStatefulWidget {
  final String prompt;
  final JournalEntry? entry;

  const JournalEditor({required this.prompt, this.entry});

  @override
  _JournalEditorState createState() => _JournalEditorState();
}

class _JournalEditorState extends ConsumerState<JournalEditor> {
  late final _titleController =
      TextEditingController(text: widget.entry?.title ?? '');
  late final _contentController =
      TextEditingController(text: widget.entry?.content ?? '');
  late bool _isBold = widget.entry?.isBold ?? false;
  late bool _isItalic = widget.entry?.isItalic ?? false;
  bool _showTitle = true;
  DateTime _lastSave = DateTime.now();
  late DateTime _selectedDate = widget.entry?.date ?? DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_contentController.text.trim().isNotEmpty) {
      final updatedEntry = JournalEntry(
        date: _selectedDate,
        title: _titleController.text,
        content: _contentController.text,
        isBold: _isBold,
        isItalic: _isItalic,
      );
      if (widget.entry != null) {
        ref
            .read(journalProvider.notifier)
            .updateEntry(widget.entry!, updatedEntry);
      } else {
        ref.read(journalProvider.notifier).saveEntry(updatedEntry);
      }
      setState(() => _lastSave = DateTime.now());
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter some content before saving.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: injector.palette.pureWhite,
                ),
          ),
          backgroundColor: injector.palette.accentColor,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: injector.palette.primaryColor,
              onPrimary: injector.palette.pureWhite,
              onSurface: injector.palette.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: injector.palette.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: injector.palette.pureWhite,
      body: Column(
        children: [
          // Toolbar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: injector.palette.pureWhite,
              boxShadow: [
                BoxShadow(
                  color: injector.palette.dividerColor.withOpacity(0.2),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.format_bold,
                    color: _isBold
                        ? injector.palette.secondaryColor
                        : injector.palette.textColor.withOpacity(0.5),
                  ),
                  onPressed: () => setState(() => _isBold = !_isBold),
                ),
                IconButton(
                  icon: Icon(
                    Icons.format_italic,
                    color: _isItalic
                        ? injector.palette.secondaryColor
                        : injector.palette.textColor.withOpacity(0.5),
                  ),
                  onPressed: () => setState(() => _isItalic = !_isItalic),
                ),
                IconButton(
                  icon: Icon(
                    Icons.calendar_month,
                    color: injector.palette.primaryColor,
                  ),
                  onPressed: () => _selectDate(context),
                ),
                IconButton(
                  icon: Icon(
                    Icons.title,
                    color: _showTitle
                        ? injector.palette.secondaryColor
                        : injector.palette.textColor.withOpacity(0.5),
                  ),
                  onPressed: () => setState(() => _showTitle = !_showTitle),
                ),
                Spacer(),
                Text(
                  DateFormat('EEEE, d MMMM').format(_selectedDate),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: injector.palette.textColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          // Prompt (if new entry)
          if (widget.entry == null && widget.prompt.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                widget.prompt,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: injector.palette.textColor.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          // Editor Fields
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showTitle)
                      TextField(
                        controller: _titleController,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: injector.palette.textColor,
                            ),
                        decoration: InputDecoration(
                          hintText: 'Enter title...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color:
                                    injector.palette.textColor.withOpacity(0.5),
                              ),
                          border: InputBorder.none,
                        ),
                      ),
                    Divider(color: injector.palette.dividerColor),
                    TextField(
                      controller: _contentController,
                      maxLines: null,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight:
                                _isBold ? FontWeight.bold : FontWeight.normal,
                            fontStyle:
                                _isItalic ? FontStyle.italic : FontStyle.normal,
                            color: injector.palette.textColor,
                          ),
                      decoration: InputDecoration(
                        hintText: 'Start writing...',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              color:
                                  injector.palette.textColor.withOpacity(0.5),
                            ),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Bar
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: injector.palette.pureWhite,
              boxShadow: [
                BoxShadow(
                  color: injector.palette.dividerColor.withOpacity(0.2),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last Saved: ${DateFormat('HH:mm').format(_lastSave)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: injector.palette.textColor.withOpacity(0.7),
                      ),
                ),
                ElevatedButton(
                  onPressed: _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: injector.palette.primaryColor,
                    foregroundColor: injector.palette.pureWhite,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Done',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
