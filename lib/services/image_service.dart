import 'package:flutter/material.dart';

import '../models/image_model.dart';
import 'database_service.dart';

class ImageService {
  final ImageDatabase _db = ImageDatabase.instance;

  Future<void> saveImage(ImageModel image) async{
    final db = await _db.database;
    await db?.insert('Images', image.toMap());
  }

  Future<void> deleteImage(int id) async {
    final db = await _db.database;
    await db?.delete('Images', where: 'id = ?', whereArgs: [id]);

  }

  Future<List<ImageModel>> getImages() async {
    final db = await _db.database;
    final result = await db!.query('Images');

    return result.map((map) => ImageModel.fromMap(map)).toList();
  }

}