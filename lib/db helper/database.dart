import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../models/Task.dart';

// ignore: camel_case_types
class Database_todo {
  late Database _db;
  static final Database_todo _databaseService = Database_todo._internal();
  factory Database_todo() => _databaseService;
  Database_todo._internal();

  Future<Database> get database async {
    if (_db == null) {
      _db = await initialise();
    }

    return _db;
  }

  Future initialise() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todoList.db');
    _db = await openDatabase(
      path,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR not null, isChecked INTEGER not null)');
      },
      version: 1,
    );
  }

  Future insertTask(Task task) async {
    final db = await _databaseService.database;
    var result = await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future getTasks() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (index) => Task.fromMap(maps[index]));
  }

  Future deleteTask(int id) async {
    final db = await _databaseService.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTask(Task task) async {
    final db = await _databaseService.database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> empty() async {
    await _db.delete('tasks');
  }

  Future toggleCheck(Task task) async {
    await _db.update('tasks', {'isChecked': task.isChecked! ? 0 : 1},
        where: 'id = ?', whereArgs: [task.id]);
  }

  Future close() async => _db.close();
}
