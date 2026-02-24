import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

abstract class GreetingExportRepository {
  // Chụp ảnh màn hình từ controller và trả về bytes
  Future<Uint8List?> captureCard(dynamic screenshotController);

  // Lưu ảnh vào thư viện thiết bị
  Future<bool> saveToGallery(Uint8List imageBytes);

  // Chia sẻ ảnh qua các ứng dụng khác
  Future<ShareResult> shareCard(Uint8List imageBytes, String message);
}
