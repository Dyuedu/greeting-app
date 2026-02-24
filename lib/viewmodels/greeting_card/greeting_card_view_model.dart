import 'dart:io';
import 'package:flutter/material.dart';
import 'package:greeting_app/data/domain/sticker_item.dart';
import 'package:greeting_app/data/repositories/contact_repository.dart';
import 'package:greeting_app/data/repositories/greeting_export_repository.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class GreetingCardViewModel extends ChangeNotifier {
  final GreetingExportRepository _exportRepository;
  final ContactRepository _contactRepository;
  File? backgroundImage;
  String message = "Chúc Mừng Năm Mới!";
  Color textColor = Colors.redAccent;
  String? selectedStickerId; // ID của sticker đang được chọn
  bool isProcessing = false; // Trạng thái đang xử lý (export/saving)
  GreetingCardViewModel(this._exportRepository, this._contactRepository);

  Future<void> exportAndSave(ScreenshotController controller) async {
    try {
      isProcessing = true;
      notifyListeners();

      // 1. Dọn dẹp UI: Bỏ chọn sticker để không dính viền xanh vào ảnh
      selectedStickerId = null;
      notifyListeners();
      // Đợi một chút để UI kịp render lại trạng thái không có viền
      await Future.delayed(const Duration(milliseconds: 100));

      // 2. Chụp ảnh thông qua Repository
      final bytes = await _exportRepository.captureCard(controller);

      if (bytes != null) {
        // 3. Lưu vào Gallery thông qua Repository
        final success = await _exportRepository.saveToGallery(bytes);
        if (!success) throw Exception("Không thể lưu ảnh vào thư viện");
      } else {
        throw Exception("Không thể chụp ảnh màn hình");
      }

      isProcessing = false;
      notifyListeners();
    } catch (e) {
      isProcessing = false;
      notifyListeners();
      rethrow; // Ném lỗi để UI xử lý hiển thị SnackBar
    }
  }

  Future<bool> exportAndShare(
    ScreenshotController controller,
    int? contactId,
  ) async {
    selectedStickerId = null;
    notifyListeners();

    final bytes = await _exportRepository.captureCard(controller);
    if (bytes != null) {
      final result = await _exportRepository.shareCard(
        bytes,
        "Chúc mừng năm mới",
      );
      return result.status == ShareResultStatus.success;
    }
    return false;
  }

  Future<bool> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(launchUri)) {
        return await launchUrl(launchUri);
      }
      return false;
    } catch (e) {
      debugPrint("Lỗi cuộc gọi: $e");
      return false;
    }
  }

  Future<void> updateContactGreetingStatus({
    required int? contactId,
    required int status,
  }) async {
    if (contactId == null) return;

    await _contactRepository.updateGreetingStatus(
      contactId: contactId,
      greetingStatus: status,
    );
    notifyListeners();
  }

  void selectSticker(String? id) {
    if (id == null) {
      selectedStickerId = null;
      notifyListeners();
      return;
    }

    selectedStickerId = id;

    // Đưa sticker lên trên cùng (Z-index)
    final index = stickers.indexWhere((s) => s.id == id);
    if (index != -1) {
      final item = stickers.removeAt(index);
      stickers.add(
        item,
      ); // Thêm lại vào cuối để Render sau cùng -> Nằm trên cùng
    }
    notifyListeners();
  }

  // Hàm cập nhật scale từ Slider
  void updateStickerScale(double newScale) {
    if (selectedStickerId == null) return;

    final index = stickers.indexWhere((s) => s.id == selectedStickerId);
    if (index != -1) {
      stickers[index].scale = newScale;
      notifyListeners();
    }
  }

  void updateStickerRotation(double newRotation) {
    if (selectedStickerId == null) return;

    final index = stickers.indexWhere((s) => s.id == selectedStickerId);
    if (index != -1) {
      stickers[index].rotation = newRotation;
      notifyListeners();
    }
  }

  void resetSticker(String id) {
    final index = stickers.indexWhere((s) => s.id == id);
    if (index != -1) {
      stickers[index].scale = 1.0;
      stickers[index].rotation = 0.0;
      notifyListeners();
    }
  }

  // Danh sách các sticker người dùng đã thêm vào thiệp
  List<StickerItem> stickers = [];

  // Thêm sticker mới từ kho
  void addSticker(String path) {
    stickers.add(StickerItem(id: DateTime.now().toString(), imagePath: path));
    notifyListeners();
  }

  void updateStickerPosition(String id, Offset delta) {
    final index = stickers.indexWhere((s) => s.id == id);
    if (index != -1) {
      Offset newPosition = stickers[index].position + delta;
      double maxX = 300.0;
      double maxY = 200.0;

      double clampedX = newPosition.dx.clamp(0.0, maxX);
      double clampedY = newPosition.dy.clamp(0.0, maxY);

      stickers[index].position = Offset(clampedX, clampedY);
      notifyListeners();
    }
  }

  void updateStickerTransform(
    String id,
    Offset delta,
    double scaleMultiplier,
    double rotationDelta,
    Size canvasSize, // Truyền kích thước canvas vào
  ) {
    final index = stickers.indexWhere((s) => s.id == id);
    if (index != -1) {
      var sticker = stickers[index];

      // 1. Tính toán vị trí mới
      double newX = sticker.position.dx + delta.dx;
      double newY = sticker.position.dy + delta.dy;

      // 2. Định nghĩa kích thước sticker (giả sử 100x100 như trong Widget)
      // Cần tính đến cả scale nếu bạn muốn chặn biên khít hoàn toàn
      const double stickerSize = 100.0;

      // 3. Chặn biên (Clamp)
      // Giới hạn X từ 0 đến (chiều rộng canvas - chiều rộng sticker)
      newX = newX.clamp(0.0, canvasSize.width - (stickerSize * sticker.scale));
      // Giới hạn Y từ 0 đến (chiều cao canvas - chiều cao sticker)
      newY = newY.clamp(0.0, canvasSize.height - (stickerSize * sticker.scale));

      sticker.position = Offset(newX, newY);

      // Cập nhật scale và rotation như cũ
      double newScale = sticker.scale * scaleMultiplier;
      sticker.scale = newScale.clamp(0.5, 4.0);
      sticker.rotation += rotationDelta;

      notifyListeners();
    }
  }

  void setTextColor(Color color) {
    textColor = color;
    notifyListeners();
  }

  void setBackgroundImage(File image) {
    print("Đã nhận ảnh tại: ${image.path}");
    if (image.existsSync()) {
      backgroundImage = image;
      notifyListeners();
    } else {
      print("File không tồn tại!");
    }
  }

  final List<String> suggestions = [
    "Chúc mừng năm mới, vạn sự như ý!",
    "An khang thịnh vượng, phát tài phát lộc.",
    "Năm mới dồi dào sức khỏe, gia đình hạnh phúc.",
    "Tết đến xuân về, triệu điều may mắn.",
  ];

  void updateMessage(String newMessage) {
    message = newMessage;
    notifyListeners();
  }

  // Thêm tính năng xóa sticker bằng cách nhấn giữ
  void removeSticker(String id) {
    stickers.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
