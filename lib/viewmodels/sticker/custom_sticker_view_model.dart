import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:greeting_app/data/domain/custom_sticker.dart';
import 'package:greeting_app/data/repositories/custom_sticker_repository.dart';
import 'package:image_picker/image_picker.dart';

class CustomStickerViewModel extends ChangeNotifier {
  CustomStickerViewModel(this._repository);

  final CustomStickerRepository _repository;

  List<CustomSticker> stickers = [];
  bool isLoading = false;
  String? error;

  Future<void> loadStickers() async {
    try {
      isLoading = true;
      notifyListeners();
      stickers = await _repository.getAllStickers();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    await _repository.addStickerFromFile(file);
    await loadStickers();
  }

  Future<void> importFromCsv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;
    if (path == null) return;

    final content = await File(path).readAsString();
    await _repository.addStickersFromCsv(content);
    await loadStickers();
  }

  Future<void> deleteSticker(int id) async {
    await _repository.deleteSticker(id);
    stickers = List<CustomSticker>.from(stickers)
      ..removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
