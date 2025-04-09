import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/providers/journal_provider.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/app_widget/custom_app_button.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';
import 'package:mindful_mate/utils/extension/widget_extension.dart';

class JournalEditor extends ConsumerStatefulWidget {
  final JournalEntry? entry; // For editing existing entries

  const JournalEditor({this.entry, super.key});

  @override
  _JournalEditorState createState() => _JournalEditorState();
}

class _JournalEditorState extends ConsumerState<JournalEditor> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  int? _selectedMoodIndex;
  bool _isBold = false;
  bool _isItalic = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
    _selectedMoodIndex = widget.entry?.moodIndex;
    _isBold = widget.entry?.isBold ?? false;
    _isItalic = widget.entry?.isItalic ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = injector.palette;

    return Scaffold(
      appBar: _buildAppBar(context, palette),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.pw(context), vertical: 2.ph(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateDisplay(context, palette),
              SizedBox(height: 2.ph(context)),
              _buildTitleField(context, palette),
              SizedBox(height: 2.ph(context)),
              _buildMoodPicker(context, palette),
              SizedBox(height: 2.ph(context)),
              _buildContentField(context, palette),
              SizedBox(height: 2.ph(context)),
              _buildFormattingButtons(context, palette),
              SizedBox(height: 2.ph(context)),
              _buildSaveButton(context, palette),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Palette palette) {
    return AppBar(
      title: Text(
        widget.entry == null ? 'New Journal Entry' : 'Edit Journal Entry',
        style: TextStyle(fontSize: 18.ww(context), color: palette.textColor),
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: palette.primaryColor, size: 20.ww(context)),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildDateDisplay(BuildContext context, Palette palette) {
    final date = widget.entry?.date ?? DateTime.now();
    return Text(
      DateFormat('MMMM dd, yyyy').format(date),
      style: TextStyle(
        fontSize: 16.ww(context),
        color: palette.textColor.withOpacity(0.7),
      ),
    );
  }

  Widget _buildTitleField(BuildContext context, Palette palette) {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: 'Enter title...',
        hintStyle: TextStyle(
          color: palette.textColor.withOpacity(0.5),
          fontSize: 16.ww(context),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.dividerColor),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.pw(context), vertical: 2.ph(context)),
      ),
      style: TextStyle(fontSize: 18.ww(context), color: palette.textColor),
      maxLines: 1,
    );
  }

  Widget _buildMoodPicker(BuildContext context, Palette palette) {
    final moods = ['😢', '😐', '😊', '😄', '🌟'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood',
          style: TextStyle(fontSize: 16.ww(context), color: palette.textColor),
        ),
        SizedBox(height: 1.ph(context)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(moods.length, (index) {
              return Padding(
                padding: EdgeInsets.only(right: 2.pw(context)),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMoodIndex = index),
                  child: Container(
                    padding: EdgeInsets.all(2.pw(context)),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedMoodIndex == index
                          ? palette.primaryColor.withOpacity(0.2)
                          : Colors.transparent,
                      border: Border.all(
                        color: _selectedMoodIndex == index
                            ? palette.primaryColor
                            : palette.dividerColor,
                      ),
                    ),
                    child: Text(
                      moods[index],
                      style: TextStyle(fontSize: 24.ww(context)),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildContentField(BuildContext context, Palette palette) {
    return TextField(
      controller: _contentController,
      decoration: InputDecoration(
        hintText: 'Write your thoughts...',
        hintStyle: TextStyle(
          color: palette.textColor.withOpacity(0.5),
          fontSize: 16.ww(context),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.dividerColor),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 4.pw(context), vertical: 2.ph(context)),
      ),
      style: TextStyle(
        fontSize: 16.ww(context),
        color: palette.textColor,
        fontWeight: _isBold ? FontWeight.bold : null,
        fontStyle: _isItalic ? FontStyle.italic : null,
      ),
      maxLines: null, // Allow unlimited lines
      minLines: 5, // Minimum visible lines
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _buildFormattingButtons(BuildContext context, Palette palette) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            Icons.format_bold,
            color: _isBold ? palette.primaryColor : palette.textColor.withOpacity(0.7),
            size: 20.ww(context),
          ),
          onPressed: () => setState(() => _isBold = !_isBold),
        ),
        IconButton(
          icon: Icon(
            Icons.format_italic,
            color: _isItalic ? palette.primaryColor : palette.textColor.withOpacity(0.7),
            size: 20.ww(context),
          ),
          onPressed: () => setState(() => _isItalic = !_isItalic),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, Palette palette) {
    return SizedBox(
      width: double.infinity,
      child: CustomAppButton(
        label: 'Save',
        onPressed: () {
          final entry = JournalEntry(
            id: widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
            date: widget.entry?.date ?? DateTime.now(),
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
            moodIndex: _selectedMoodIndex,
            isBold: _isBold,
            isItalic: _isItalic,
          );
          ref.read(journalProvider.notifier).saveEntry(context, entry);
          Navigator.pop(context);
        },
        backgroundColor: palette.primaryColor,
        foregroundColor: palette.pureWhite,
        height: 56.hh(context),
      ),
    );
  }
}