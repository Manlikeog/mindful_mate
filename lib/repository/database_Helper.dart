import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';
import 'package:mindful_mate/screens/mood/model/mood_entry.dart';
import 'package:mindful_mate/providers/journal_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'mental_health.db');

    return await openDatabase(
      path,
      version: 3, // Increment to 3 for journals
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE user_progress (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          streakCount INTEGER,
          totalPoints INTEGER,
          level INTEGER,
          badges TEXT,
          lastLogDate TEXT
        )
        ''');
        await db.execute('''
        CREATE TABLE moods (
          date TEXT PRIMARY KEY,
          moodRating INTEGER,
          note TEXT
        )
        ''');
        await db.execute('''
        CREATE TABLE journals (
          date TEXT PRIMARY KEY,
          content TEXT,
          title TEXT,
          moodIndex INTEGER,
          isBold INTEGER,
          isItalic INTEGER
        )
        ''');
        await db.insert('user_progress', UserProgress().toMap());
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
          CREATE TABLE moods (
            date TEXT PRIMARY KEY,
            moodRating INTEGER,
            note TEXT
          )
          ''');
        }
        if (oldVersion < 3) {
          await db.execute('''
          CREATE TABLE journals (
            date TEXT PRIMARY KEY,
            content TEXT,
            title TEXT,
            moodIndex INTEGER,
            isBold INTEGER,
            isItalic INTEGER
          )
          ''');
        }
      },
      onOpen: (db) async {
        final count = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM user_progress'));
        if (count == 0) {
          await db.insert('user_progress', UserProgress().toMap());
        }
      },
    );
  }

  Future<UserProgress> getUserProgress() async {
    final db = await database;
    final result = await db.query('user_progress', limit: 1);
    return UserProgress.fromMap(result.first);
  }

  Future<void> updateUserProgress(UserProgress progress) async {
    final db = await database;
    await db.update('user_progress', progress.toMap(),
        where: 'id = ?', whereArgs: [1]);
  }

  Future<List<MoodEntry>> getMoodEntries() async {
    final db = await database;
    final result = await db.query('moods');
    return result.map((map) => MoodEntry.fromMap(map)).toList();
  }

  Future<void> saveMoodEntry(MoodEntry entry) async {
    final db = await database;
    await db.insert('moods', entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    final db = await database;
    final result = await db.query('journals');
    return result
        .map((map) => JournalEntry(
              date: DateTime.parse(map['date'] as String),
              content: map['content'] as String,
              title: map['title'] as String,
              moodIndex: map['moodIndex'] as int?,
              isBold: (map['isBold'] as int) == 1,
              isItalic: (map['isItalic'] as int) == 1,
            ))
        .toList();
  }

  Future<void> saveJournalEntry(JournalEntry entry) async {
    final db = await database;
    await db.insert(
        'journals',
        {
          'date': entry.date.toIso8601String(),
          'content': entry.content,
          'title': entry.title,
          'moodIndex': entry.moodIndex,
          'isBold': entry.isBold ? 1 : 0,
          'isItalic': entry.isItalic ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteJournalEntry(JournalEntry entry) async {
    final db = await database;
    await db.delete('journals',
        where: 'date = ?', whereArgs: [entry.date.toIso8601String()]);
  }

  Future<void> clearJournalEntries() async {
    final db = await database;
    await db.delete('journals');
  }
}
