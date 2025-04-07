// lib/screens/journal/widgets/journal_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const JournalCard({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final palette = injector.palette;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: palette.pureWhite,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, palette),
            if (entry.title != null && entry.title!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildTitle(context, palette),
            ],
            const SizedBox(height: 8),
            _buildContent(context, palette),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Palette palette) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (entry.moodIndex != null)
              Text(
                ['😢', '😐', '😊', '😄', '🌟'][entry.moodIndex!],
                style: const TextStyle(fontSize: 20),
              ),
            const SizedBox(width: 8),
            Text(
              DateFormat('MMM dd').format(entry.date),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: palette.textColor.withOpacity(0.7),
                  ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 20, color: palette.secondaryColor),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 20, color: palette.accentColor),
              onPressed: onDelete,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, Palette palette) {
    return Text(
      entry.title!,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: palette.textColor,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContent(BuildContext context, Palette palette) {
    return Text(
      entry.content,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: entry.isBold ? FontWeight.bold : null,
            fontStyle: entry.isItalic ? FontStyle.italic : null,
            color: palette.textColor.withOpacity(0.85),
          ),
    );
  }
}