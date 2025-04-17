// test/challenge_complexity_index_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/providers/progress_provider.dart';
import 'package:mindful_mate/providers/challenge_provider.dart';
import 'package:mindful_mate/data/model/challenge/challenge.dart';
import 'fakes/fake_database_helper.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(overrides: [
      // Seed a fake DB so progressProvider & challengeProvider work
      databaseHelperProvider.overrideWithProvider(
        Provider((_) => FakeDatabaseHelper()),
      ),
    ]);
  });

  tearDown(() => container.dispose());

  test('Challenge Complexity Index via real challengeProvider', () {
    // GIVEN: the static level 1 challenges are defined in your app
    final challenges = container.read(challengesProvider);

    // WHEN: we compute the average goal (i.e. complexity index)
    final totalGoals = challenges.map((c) => c.goal).reduce((a, b) => a + b);
    final complexityIndex = totalGoals / challenges.length;

    // THEN: it matches the expected average for level 1
    // level 1 goals are [3,2,3,3], so (3+2+3+3)/4 = 2.75
    expect(complexityIndex, closeTo(2.75, 1e-6));
  });
}
