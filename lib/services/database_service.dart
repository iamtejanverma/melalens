import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageDatabase {
  static Database? _database;
  static final ImageDatabase instance = ImageDatabase._init();
  ImageDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB('images.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute( '''
        CREATE TABLE Images (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        path TEXT NOT NULL,
        thumbnail TEXT NOT NULL,
        tags TEXT
        )
        ''');
  }
       
  Future<void> deleteImage(int id) async {
    final db = await instance.database;
    await db?.delete('Images', where: 'id = ?', whereArgs: [id]);
  }
  Future<void> insertImage(String path) async{
    final db = await instance.database;
    await db?.insert('Images', {'path': path});
  }

  Future<List<Map<String, dynamic >>> getImages() async {
    final db = await instance.database;
    return await db!.query('Images');
  }

  Future close() async {
    final db = await instance.database;
    db?.close();
  }

}