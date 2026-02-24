import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:greeting_app/data/repositories/greeting_export_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class GreetingExportRepositoryImpl implements GreetingExportRepository {
  @override
  Future<Uint8List?> captureCard(dynamic screenshotController) async {
    final controller = screenshotController as ScreenshotController;
    return await controller.capture(pixelRatio: 3.0);
  }

  @override
  Future<bool> saveToGallery(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path =
          '${tempDir.path}/greeting_card_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(imageBytes);

      await Gal.putImage(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ShareResult> shareCard(Uint8List imageBytes, String message) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File(
      '${tempDir.path}/greeting_card_${DateTime.now().millisecondsSinceEpoch}.png',
    ).create();
    await file.writeAsBytes(imageBytes);

    // Lưu ý: await ở đây sẽ đợi cho đến khi người dùng đóng bảng chia sẻ của hệ thống
    return await Share.shareXFiles([XFile(file.path)], text: message);
  }
}
