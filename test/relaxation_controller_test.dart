import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/controller/relaxation_controller.dart';
import 'package:mindful_mate/data/model/relaxation/relaxation.dart';
import 'package:mindful_mate/data/model/progress_card/user_progress.dart';

/// A dummy BuildContext that bypasses all calls via noSuchMethod
class FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Dummy Ref stub
class FakeRef implements Ref {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Dummy GamificationController stub
class FakeGamificationController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('RelaxationController', () {
    final controller = RelaxationController( FakeRef());

    test('completeRelaxation invokes onFeedback with positive result', () async {
      var progress = UserProgress();
      bool feedback = false;
      final exercise = Relaxation(
        id: 'r1', title: 'Test', level: 1, duration: 5, description: '',
      );

      await controller.completeRelaxation(
        context: FakeBuildContext(),
        progress: progress,
        exercise: exercise,
        isSuggested: true,
        onFeedback: (_) => feedback = true,
      );

      expect(feedback, isTrue);
    });
  });
}