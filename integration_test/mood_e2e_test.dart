import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mindful_mate/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Mood logging flow: Progress → MoodTracker → Log Mood',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

       // 2. Bypass onboarding (adjust keys/text as needed)
    final next = find.byKey(ValueKey('onboarding_next'));
    if (await tester.pumpAndSettle().then((_) => next.evaluate().isNotEmpty)) {
      await tester.tap(next);
      await tester.pumpAndSettle();
    }

    // Navigate to MoodTracker
    final goToMood = find.byKey(const Key('goToMoodButton'));
    expect(goToMood, findsOneWidget);
    await tester.tap(goToMood);
    await tester.pumpAndSettle();

    // Tap a day on the calendar (text should match visible day number, e.g. '15')
    final day = DateTime.now().day;
    final dayCell = find.text(day.toString()); // adjust to a valid date in calendar view
    expect(dayCell, findsWidgets);
    await tester.tap(dayCell);
    await tester.pumpAndSettle();

    // Tap an emoji in the mood picker
    final moodEmoji = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.text('😊'),
    );
    expect(moodEmoji, findsOneWidget);
    await tester.tap(moodEmoji);
    await tester.pumpAndSettle();

    // Confirm mood was logged
    expect(find.textContaining('Mood logged!'), findsOneWidget);
  });
}
