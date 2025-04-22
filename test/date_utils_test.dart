import 'package:flutter_test/flutter_test.dart';
import 'package:mindful_mate/utils/date_utils.dart';

void main() {
  test('isSameDay respects day boundaries', () {
    final a = DateTime(2025,4,21,0,0,0);
    final b = DateTime(2025,4,21,23,59,59);
    expect(isSameDay(a,b), isTrue);
  });
}