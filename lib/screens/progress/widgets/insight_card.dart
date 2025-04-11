import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful_mate/providers/insight/insight_card_provider.dart';
import 'package:mindful_mate/screens/relaxations/relaxation_screen.dart';
import 'package:mindful_mate/utils/extension/auto_resize.dart';

class InsightsCard extends ConsumerWidget {
  const InsightsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(insightsCardProvider);
    return Padding(
      padding: EdgeInsets.only(
        left: 4.pw(context),
        right: 4.pw(context),
        top: 2.ph(context),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade50, Colors.blue.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(4.pw(context)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.insights,
                      color: Colors.purple.shade600, size: 20.ww(context)),
                  SizedBox(width: 2.pw(context)),
                  Expanded(
                    child: Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 16.ww(context),
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.ph(context)),
              Text(
                data.insightText,
                style: TextStyle(
                    fontSize: 14.ww(context),
                    height: 1.4,
                    color: Colors.black87),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.ph(context)),
              Text(
                data.dateRange,
                style: TextStyle(
                  fontSize: 12.ww(context),
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.ph(context)),
              ElevatedButton(
                onPressed: () {
                  context.push(
                    RelaxationScreen.fullPath,
                    extra: data.suggestedExercise,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: 4.pw(context), vertical: 1.ph(context)),
                  textStyle: TextStyle(fontSize: 12.ww(context)),
                ),
                child: const Text('Try This Relaxation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
