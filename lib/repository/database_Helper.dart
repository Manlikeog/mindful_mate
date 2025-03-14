import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mindful_mate/providers/gamification/user_progress.dart';

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
    // Get the app's documents directory using path_provider
    final directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'mental_health.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_progress (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            streakCount INTEGER,
            totalPoints INTEGER,
            level INTEGER,
            badges TEXT
          )
        ''');
        await db.insert('user_progress', UserProgress().toMap());
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
}
