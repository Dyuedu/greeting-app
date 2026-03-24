import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';
import 'package:greeting_app/core/widgets/draggable_sticker.dart';
import 'package:greeting_app/viewmodels/greeting_card/greeting_card_view_model.dart';
import 'package:provider/provider.dart';

class GreetingCardCanvas extends StatelessWidget {
  final Function(String stickerId) onDeleteRequest;

  const GreetingCardCanvas({super.key, required this.onDeleteRequest});

  @override
  Widget build(BuildContext context) {
    return Consumer<GreetingCardViewModel>(
      builder: (context, vm, child) {
        return AspectRatio(
          aspectRatio: 1.4,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Lấy kích thước thực tế của vùng thiệp để giới hạn di chuyển
                final Size canvasSize = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );

                return Stack(
                  children: [
                    // 1. Lớp Ảnh nền
                    _buildBackground(vm),

                    // 2. Lớp Lời chúc (Text overlay)
                    _buildMessage(context, vm),

                    // 3. Lớp Danh sách Sticker
                    ...vm.stickers.map((sticker) {
                      return DraggableSticker(
                        key: ValueKey(sticker.id),
                        sticker: sticker,
                        isSelected: vm.selectedStickerId == sticker.id,
                        onTransform: (delta, scale, rotation) {
                          if (vm.selectedStickerId != sticker.id) {
                            vm.selectSticker(sticker.id);
                          }
                          vm.updateStickerTransform(
                            sticker.id,
                            delta,
                            scale,
                            rotation,
                            canvasSize,
                          );
                        },
                        onTap: () => vm.selectSticker(sticker.id),
                        onDoubleTap: () => vm.resetSticker(sticker.id),
                        onLongPress: () => onDeleteRequest(sticker.id),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackground(GreetingCardViewModel vm) {
    return Positioned.fill(
      child: vm.backgroundImage != null
          ? Image.file(
              vm.backgroundImage!,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            )
          : vm.backgroundAssetPath != null
          ? Image.asset(vm.backgroundAssetPath!, fit: BoxFit.cover)
          : Container(
              color: TetColors.warmCream,
              child: Icon(
                Icons.image,
                color: TetColors.luckyRedLight.withOpacity(0.6),
                size: 50,
              ),
            ),
    );
  }

  Widget _buildMessage(BuildContext context, GreetingCardViewModel vm) {
    return Center(
      child: Padding(
        // Padding lớn hơn để không đè lên viền hoặc sticker cố định ở góc
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: ConstrainedBox(
          // Giới hạn vùng chứa text không được vượt quá 80% chiều cao thiệp
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown, // Tự động thu nhỏ chữ nếu nội dung quá dài
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(
                context,
              ).size.width, // Tạo chiều rộng ảo để text xuống dòng
              child: Text(
                vm.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: vm.textColor,
                  fontSize: 30, // Kích thước gốc, sẽ bị scale down nếu cần
                  fontWeight: FontWeight.bold,
                  fontFamily: vm.messageFontFamily,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 10,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
