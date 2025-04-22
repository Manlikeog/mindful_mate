import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mindful_mate/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-end flow', (WidgetTester tester) async {
    // Launch the app
    app.main();
    await tester.pumpAndSettle();


    // Tap the AppBar button to go to /challenges
    final goButton = find.byKey(const Key('goToChallengesButton'));
    expect(goButton, findsOneWidget);
    await tester.tap(goButton);
    await tester.pumpAndSettle();

    // Now on ChallengesScreen: verify at least one 'relaxation' icon is present
    // Icons.self_improvement is the mapped icon for type 'relaxation'
    expect(find.byIcon(Icons.self_improvement), findsWidgets);
  });
}
