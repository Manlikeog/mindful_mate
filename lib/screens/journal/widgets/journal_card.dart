import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

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
      margin: EdgeInsets.symmetric(vertical: 1.ph(context), horizontal: 2.pw(context)),
      child: Padding(
        padding: EdgeInsets.all(3.pw(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, palette),
            if (entry.title != null && entry.title!.trim().isNotEmpty) ...[
              SizedBox(height: 2.ph(context)),
              _buildTitle(context, palette),
            ],
            SizedBox(height: 2.ph(context)),
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
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (entry.moodIndex != null)
                Text(
                  ['😢', '😐', '😊', '😄', '🌟'][entry.moodIndex!],
                  style: TextStyle(fontSize: 16.ww(context)), // Reduced size
                ),
              SizedBox(width: 2.pw(context)),
              Flexible(
                child: Text(
                  DateFormat('MMM dd').format(entry.date),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: palette.textColor.withOpacity(0.7),
                        fontSize: 14.ww(context),
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 16.ww(context), color: palette.secondaryColor),
              padding: EdgeInsets.zero, // Reduce padding
              constraints: BoxConstraints.tight(Size(36.ww(context), 36.ww(context))), // Smaller touch area
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 16.ww(context), color: palette.accentColor),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tight(Size(36.ww(context), 36.ww(context))),
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
            fontSize: 18.ww(context),
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
            fontSize: 14.ww(context),
          ),
    );
  }
}