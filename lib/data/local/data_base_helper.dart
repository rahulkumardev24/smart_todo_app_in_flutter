import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  // Create Private Constructor For Singleton Pattern
  DataBaseHelper._privateConstructor();

  // Create Singleton instance
  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  // Table and column names
  static final String todoTable = "TodoData";
  static final String columnTodoSno = "s_no";
  static final String columnTodoTitle = "title";
  static final String columnTodoMessage = "message";
  static final String columnTodoIsDone = "is_done"; // Corrected to string
  static final String columnTodoDate = "date"; // New date column

  // Database instance
  Database? _database;

  // If database is not created then create database; if database is already created then open the database
  Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _openDb();
    return _database!;
  }

  // Open Database
  Future<Database> _openDb() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(appDirectory.path, "todo.db");
    return await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE $todoTable ("
              "$columnTodoSno INTEGER PRIMARY KEY AUTOINCREMENT, "
              "$columnTodoTitle TEXT, "
              "$columnTodoMessage TEXT, "
              "$columnTodoIsDone INTEGER, " // Store boolean as integer
              "$columnTodoDate TEXT" // Store date as TEXT
              ")"
      );
    });
  }

  // Insert todo
  Future<int> addTodo({
    required String title,
    required String message,
  }) async {
    final db = await _db;
    String formattedDate = DateTime.now().toString();
    return await db.insert(todoTable, {
      columnTodoTitle: title,
      columnTodoMessage: message,
      columnTodoIsDone: 0, // Assuming default is not done
      columnTodoDate: formattedDate,
    });
  }


  // Get all todos
  Future<List<Map<String, dynamic>>> getAllTodos() async {
    final db = await _db;
    return await db.query(todoTable);
  }

  // Update a todo
  Future<int> updateTodo({
    required int id,
    required String title,
    required String message,
    required String date,
  }) async {
    final db = await _db;
    return await db.update(
      todoTable,
      {
        columnTodoTitle: title,
        columnTodoMessage: message,
        columnTodoDate: date,
      },
      where: '$columnTodoSno = ?',
      whereArgs: [id],
    );
  }

  // Delete a todo
  Future<int> deleteTodo({
    required int id,
  }) async {
    final db = await _db;
    return await db.delete(
      todoTable,
      where: '$columnTodoSno = ?',
      whereArgs: [id],
    );
  }

  // Search todos
  Future<List<Map<String, dynamic>>> searchTodos(String keyword) async {
    final db = await _db;
    return await db.query(
      todoTable,
      where: '$columnTodoTitle LIKE ? OR $columnTodoMessage LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
  }

  Future<int> updateTodoStatus({
    required int id,
    required bool isDone,
  }) async {
    final db = await _db;
    return await db.update(
      todoTable,
      {
        columnTodoIsDone: isDone ? 1 : 0,
      },
      where: '$columnTodoSno = ?',
      whereArgs: [id],
    );
  }

}
