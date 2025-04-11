import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class JournalCard extends StatefulWidget {
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
  State<JournalCard> createState() => _JournalCardState();
}

class _JournalCardState extends State<JournalCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final palette = injector.palette;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.pw(context))),
      color: palette.pureWhite,
      margin: EdgeInsets.symmetric(vertical: 1.ph(context), horizontal: 2.pw(context)),
      child: Padding(
        padding: EdgeInsets.all(3.pw(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, palette),
            if (widget.entry.title != null && widget.entry.title!.trim().isNotEmpty) ...[
              SizedBox(height: 2.ph(context)),
              _buildTitle(context, palette),
            ],
            SizedBox(height: 2.ph(context)),
            _buildContent(context, palette),
            if (widget.entry.content.length > 100) // Show button only for long content
              _buildShowMoreButton(context, palette),
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
              if (widget.entry.moodIndex != null)
                Text(
                  ['😢', '😐', '😊', '😄', '🌟'][widget.entry.moodIndex!],
                  style: TextStyle(fontSize: 16.ww(context)),
                ),
              SizedBox(width: 2.pw(context)),
              Flexible(
                child: Text(
                  DateFormat('MMM dd').format(widget.entry.date),
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
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tight(Size(10.pw(context), 10.pw(context))),
              onPressed: widget.onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 16.ww(context), color: palette.accentColor),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tight(Size(10.pw(context), 10.pw(context))),
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, Palette palette) {
    return Text(
      widget.entry.title!,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: palette.textColor,
            fontSize: 18.ww(context),
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContent(BuildContext context, Palette palette) {
    return AnimatedCrossFade(
      firstChild: Text(
        widget.entry.content,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: widget.entry.isBold ? FontWeight.bold : null,
              fontStyle: widget.entry.isItalic ? FontStyle.italic : null,
              color: palette.textColor.withOpacity(0.85),
              fontSize: 14.ww(context),
            ),
      ),
      secondChild: Text(
        widget.entry.content,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: widget.entry.isBold ? FontWeight.bold : null,
              fontStyle: widget.entry.isItalic ? FontStyle.italic : null,
              color: palette.textColor.withOpacity(0.85),
              fontSize: 14.ww(context),
            ),
      ),
      crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildShowMoreButton(BuildContext context, Palette palette) {
    return Padding(
      padding: EdgeInsets.only(top: 1.ph(context)),
      child: TextButton(
        onPressed: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Text(
          _isExpanded ? 'Show Less' : 'Show More',
          style: TextStyle(
            color: palette.primaryColor,
            fontSize: 12.ww(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}