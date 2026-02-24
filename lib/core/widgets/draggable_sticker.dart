

import 'package:flutter/material.dart';
import 'package:greeting_app/data/domain/sticker_item.dart';

class DraggableSticker extends StatelessWidget {
  final StickerItem sticker;
  final Function(Offset delta, double scale, double rotation) onTransform;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final bool isSelected;
  const DraggableSticker({
    super.key,
    required this.sticker,
    required this.onTransform,
    required this.onLongPress,
    required this.onTap,
    required this.isSelected,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(sticker.position.dx, sticker.position.dy)
        ..rotateZ(sticker.rotation)
        ..scale(sticker.scale),
      child: GestureDetector(
        onTap: onTap,
        onScaleUpdate: (details) {
          onTransform(details.focalPointDelta, details.scale, details.rotation);
        },
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: RepaintBoundary(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              // Hiện viền xanh nếu sticker đang được chọn
              border: Border.all(
                color: isSelected ? Colors.blueAccent : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              sticker.imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
