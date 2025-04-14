import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

/// Represents a journal entry with text and formatting options.
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

  /// Creates a copy with updated fields.
  JournalEntry copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? content,
    int? moodIndex,
    bool? isBold,
    bool? isItalic,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
      moodIndex: moodIndex ?? this.moodIndex,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
    );
  }
}