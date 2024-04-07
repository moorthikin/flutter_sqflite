import 'dart:async';
import 'dart:core';

import 'package:flutter_sqflite/model/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _dbvesrion = 1;
  static const String _dbname = 'moorthidb';

  static Future<Database> _getDb() async {
    return openDatabase(join(await getDatabasesPath(), _dbname),
        onCreate: (db, version) async => await db.execute(
            'CREATE TABLE Note (id INTEGER PRIMARY KEY, title TEXT, description TEXT)'),
        version: _dbvesrion);
  }

  static Future<int> addNote(Note note) async {
    final db = await _getDb();
    return await db.insert('Note', note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateNote(Note note) async {
    final db = await _getDb();
    return await db.update("Note", note.toJson(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNote(Note note) async {
    final db = await _getDb();
    return await db.delete("Note", where: 'id=?', whereArgs: [note.id]);
  }

  static Future<List<Note>?> getAllNotes() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps = await db.query("Note");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Note.fromJson(maps[index]));
  }
}
