import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation_card.dart';
import 'package:mindful_mate/utils/app_settings/palette.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class RelaxationCard extends StatefulWidget {
  final RelaxationCardData cardData;
  final Palette palette;

  const RelaxationCard({
    required this.cardData,
    required this.palette,
    super.key,
  });

  @override
  State<RelaxationCard> createState() => _RelaxationCardState();
}

class _RelaxationCardState extends State<RelaxationCard> {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.cardData.exercise.duration * 60; // Convert minutes to seconds
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isActive || widget.cardData.isCompletedToday) return;

    setState(() {
      _isActive = true;
      widget.cardData.isExpanded = true; // Auto-expand when starting
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _completeRelaxation();
        setState(() {
          _isActive = false;
          _remainingSeconds = widget.cardData.exercise.duration * 60; // Reset
        });
      }
    });
  }

  void _completeRelaxation() {
    widget.cardData.completeRelaxation(context);
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 2.ph(context)),
      child: Card(
        elevation: widget.cardData.isSuggested ? 8 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.pw(context))),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.cardData.isSuggested
                  ? [Colors.purple.shade200, Colors.blue.shade200]
                  : [Colors.white, Colors.grey.shade100],
            ),
            borderRadius: BorderRadius.circular(4.pw(context)),
            boxShadow: widget.cardData.isSuggested
                ? [
                    BoxShadow(
                        color: Colors.purple.shade100,
                        blurRadius: 3.pw(context),
                        spreadRadius: 0.5.pw(context))
                  ]
                : null,
          ),
          child: Column(
            children: [
              _buildListTile(context),
              _buildExpandedContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.self_improvement,
        color: widget.palette.primaryColor,
        size: 8.pw(context),
      ),
      title: Text(
        widget.cardData.exercise.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: widget.palette.textColor,
          fontSize: 14.ww(context),
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text(
            'Level ${widget.cardData.exercise.level}',
            style: TextStyle(
              color: widget.palette.textColor.withOpacity(0.7),
              fontSize: 12.ww(context),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(width: 2.pw(context)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.pw(context), vertical: 0.5.ph(context)),
            decoration: BoxDecoration(
              color: widget.palette.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${widget.cardData.exercise.duration} min',
              style: TextStyle(
                fontSize: 12.ww(context),
                color: widget.palette.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.cardData.isCompletedToday)
            AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 6.pw(context),
              ),
            ),
          IconButton(
            icon: Icon(
              widget.cardData.isExpanded ? Icons.expand_less : Icons.expand_more,
              color: widget.palette.textColor,
              size: 6.pw(context),
            ),
            padding: EdgeInsets.all(1.pw(context)),
            constraints: BoxConstraints.tight(Size(10.pw(context), 10.pw(context))),
            onPressed: () => widget.cardData.toggleExpansion(),
          ),
        ],
      ),
      onTap: () => widget.cardData.toggleExpansion(),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: Padding(
        padding: EdgeInsets.all(4.pw(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.cardData.exercise.description,
              style: TextStyle(
                color: widget.palette.textColor.withOpacity(0.8),
                fontSize: 12.ww(context),
              ),
            ),
            SizedBox(height: 2.ph(context)),
            if (_isActive) ...[
              Center(
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 20.ww(context),
                    fontWeight: FontWeight.bold,
                    color: widget.palette.accentColor,
                  ),
                ),
              ),
              SizedBox(height: 2.ph(context)),
            ],
            Center(
              child: ElevatedButton(
                onPressed: widget.cardData.isCompletedToday || _isActive ? null : _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.cardData.isSuggested
                      ? Colors.purple.shade600
                      : widget.palette.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 6.pw(context), vertical: 2.ph(context)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.pw(context))),
                  textStyle: TextStyle(fontSize: 12.ww(context)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.cardData.isCompletedToday
                        ? 'Done Today'
                        : _isActive
                            ? 'In Progress'
                            : 'Start'),
                    if (widget.cardData.isSuggested && !widget.cardData.isCompletedToday && !_isActive) ...[
                      SizedBox(width: 2.pw(context)),
                      AnimatedScale(
                        scale: 1.1,
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                        child: Icon(Icons.star, size: 4.pw(context)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      crossFadeState:
          widget.cardData.isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }
}