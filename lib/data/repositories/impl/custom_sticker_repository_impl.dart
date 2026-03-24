import 'dart:convert';
import 'dart:io';

import 'package:greeting_app/data/domain/custom_sticker.dart';
import 'package:greeting_app/data/local/daos/custom_sticker_dao.dart';
import 'package:greeting_app/data/repositories/custom_sticker_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CustomStickerRepositoryImpl implements CustomStickerRepository {
  CustomStickerRepositoryImpl(this._dao);

  final CustomStickerDao _dao;

  @override
  Future<List<CustomSticker>> getAllStickers() {
    return _dao.getAllStickers();
  }

  @override
  Future<void> addStickerFromFile(XFile file) async {
    final savedPath = await _saveToAppDirectory(File(file.path), file.name);
    final sticker = CustomSticker(
      localPath: savedPath,
      name: file.name,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _dao.insertSticker(sticker);
  }

  @override
  Future<void> addStickersFromCsv(String csvContent) async {
    final lines = const LineSplitter().convert(csvContent);
    final List<CustomSticker> buffer = [];

    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;
      if (_isHeaderLine(line)) continue;

      final separatorIndex = line.indexOf(',');
      if (separatorIndex == -1) continue;

      final name = line.substring(0, separatorIndex).trim();
      final pathValue = line.substring(separatorIndex + 1).trim().replaceAll('"', '');
      if (pathValue.isEmpty) continue;

      final file = File(pathValue);
      if (!file.existsSync()) continue;

      final savedPath = await _saveToAppDirectory(file, name.isEmpty ? null : name);
      buffer.add(
        CustomSticker(
          localPath: savedPath,
          name: name.isEmpty ? p.basename(file.path) : name,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }

    if (buffer.isNotEmpty) {
      await _dao.insertStickers(buffer);
    }
  }

  @override
  Future<void> deleteSticker(int id) async {
    final sticker = await _dao.getStickerById(id);
    if (sticker != null) {
      final file = File(sticker.localPath);
      if (file.existsSync()) {
        await file.delete();
      }
    }
    await _dao.deleteSticker(id);
  }

  Future<String> _saveToAppDirectory(File source, String? preferredName) async {
    final dir = await _ensureStickerDirectory();
    final baseName = preferredName ?? p.basename(source.path);
    final sanitized = baseName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_$sanitized';
    final destination = File(p.join(dir.path, fileName));
    final copied = await source.copy(destination.path);
    return copied.path;
  }

  Future<Directory> _ensureStickerDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final stickerDir = Directory(p.join(docsDir.path, 'stickers'));
    if (!await stickerDir.exists()) {
      await stickerDir.create(recursive: true);
    }
    return stickerDir;
  }

  bool _isHeaderLine(String line) {
    final lowered = line.toLowerCase();
    return lowered.contains('name') && lowered.contains('path');
  }
}
