import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + "task.db";
        log("path: " + _path, name: "DB");
        _db = await openDatabase(_path, version: 1,
            onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING, note TEXT, date STRING, '
              'startTime STRING, endTime String, '
              'remind INTEGER, repeat STRING, '
              'color INTEGER, '
              'isCompleted INTEGER)');
        });
      } catch (e) {
        log("Error: " + e.toString(), name: "DB");
      }
    }
  }

  static Future<int> insert(Task task) async {
    return await _db!.insert(_tableName, task.toJson());
  }

  static Future<int> delete(Task task) async {
    return await _db!.delete(_tableName, where: "id = ?", whereArgs: [task.id]);
  }

  static Future<int> upate(int id) async {
    return await _db!.rawUpdate('''

     UPDATE tasks SET isCompleted = ? WHERE id = ? 

    ''', [1, id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }
}
