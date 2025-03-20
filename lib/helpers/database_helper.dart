import 'package:quiz_flutter/models/question.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('quiz.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        options TEXT NOT NULL,
        answer INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      INSERT INTO questions (question, options, answer)
      VALUES
        ('What is 1 + 1?', '1,2,3,4', 2),
        ('What is 2 - 1?', '1,2,3,4', 1),
        ('What is 3 * 3?', '6,9,12,15', 9),
        ('What is 4 / 2?', '1,2,3,4', 2),
        ('What is 5 + 5?', '8,9,10,11', 10),
        ('What is 6 - 3?', '2,3,4,5', 3),
        ('What is 7 * 7?', '42,49,56,63', 49),
        ('What is 8 / 2?', '2,3,4,5', 4),
        ('What is 9 + 9?', '16,17,18,19', 18),
        ('What is 10 - 5?', '3,4,5,6', 5)
    ''');
  }

  Future<List<Question>> getQuestions() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('questions');

    return List.generate(maps.length, (i) {
      return Question(
        id: maps[i]['id'],
        question: maps[i]['question'],
        options: maps[i]['options'].split(','),
        answer: maps[i]['answer'],
      );
    });
  }
}
