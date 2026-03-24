import 'package:greeting_app/data/domain/custom_sticker.dart';
import 'package:image_picker/image_picker.dart';

abstract class CustomStickerRepository {
  Future<List<CustomSticker>> getAllStickers();
  Future<void> addStickerFromFile(XFile file);
  Future<void> addStickersFromCsv(String csvContent);
  Future<void> deleteSticker(int id);
}
