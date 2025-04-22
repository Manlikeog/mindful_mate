import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mindful_mate/controller/journal_controller.dart';
import 'package:mindful_mate/data/model/journal/journal_entry.dart';
import 'fakes/fake_database_helper.dart';

// Dummy Ref implementation for testing
class _FakeRef extends Fake implements Ref {}

void main() {
  final fakeDb = FakeDatabaseHelper();
  final ref = _FakeRef();
  final jc = JournalController(fakeDb, ref);

  test('createNewEntry handles empty title', () {
    final entry = jc.createNewEntry(
      date: DateTime.now(),
      title: '',
      content: 'Hello',
      moodIndex: null,
      isBold: false,
      isItalic: false,
    );
    expect(entry.title, isNull);
    expect(entry.content, 'Hello');
  });
}