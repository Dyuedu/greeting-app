import 'dart:ui';

class StickerItem {
  final String id;
  final String imagePath;
  Offset position;
  double scale;
  double rotation;

  StickerItem({
    required this.id, 
    required this.imagePath, 
    this.position = const Offset(100, 100),
    this.scale = 1.0,
    this.rotation = 0.0,
  });
}