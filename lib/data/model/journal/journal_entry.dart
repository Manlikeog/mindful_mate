import 'package:hive/hive.dart';

part 'journal_entry.g.dart'; // This will be generated

@HiveType(typeId: 0)
class JournalEntry {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String? title;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final int? moodIndex;

  @HiveField(5)
  final bool isBold;

  @HiveField(6)
  final bool isItalic;

  JournalEntry({
    required this.id,
    required this.date,
    this.title,
    required this.content,
    this.moodIndex,
    this.isBold = false,
    this.isItalic = false,
  });
}