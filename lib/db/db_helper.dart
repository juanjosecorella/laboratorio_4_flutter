import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            confirmed INTEGER NOT NULL default 0
          );

          CREATE TABLE task_collections (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,

          );
        ''');
      },
    );
  }

  Future<int> insertTask(String title) async {
    final db = await database;
    return await db.insert('tasks', {'title': title});
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final result = await db.query('tasks');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> confirmTask(int id) async {
    final db = await database;
    return await db.update("tasks", where: 'id = ?', whereArgs: [id], { 'confirmed': 1 });
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}

Future<void> deleteLocalDatabase() async {
  final dbPath = await getDatabasesPath();
  print("\n\n" + "eliminando en path: " + dbPath );
  final path = join(dbPath, 'tasks.db');
  await deleteDatabase(path);
}
