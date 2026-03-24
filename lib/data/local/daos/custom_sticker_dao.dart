import 'package:greeting_app/data/domain/custom_sticker.dart';
import 'package:greeting_app/data/local/app_database.dart';
import 'package:sqflite/sqflite.dart';

class CustomStickerDao {
  final AppDatabase _dbHelper = AppDatabase.instance;

  Future<int> insertSticker(CustomSticker sticker) async {
    final db = await _dbHelper.database;
    return db.insert(
      'custom_stickers',
      sticker.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertStickers(List<CustomSticker> stickers) async {
    if (stickers.isEmpty) return;
    final db = await _dbHelper.database;
    final batch = db.batch();

    for (final sticker in stickers) {
      batch.insert(
        'custom_stickers',
        sticker.toMap()..remove('id'),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<CustomSticker>> getAllStickers() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'custom_stickers',
      orderBy: 'createdAt DESC',
    );
    return result.map(CustomSticker.fromMap).toList();
  }

  Future<CustomSticker?> getStickerById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'custom_stickers',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return CustomSticker.fromMap(result.first);
  }

  Future<int> deleteSticker(int id) async {
    final db = await _dbHelper.database;
    return db.delete('custom_stickers', where: 'id = ?', whereArgs: [id]);
  }
}
