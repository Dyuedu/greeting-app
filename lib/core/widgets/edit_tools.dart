import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/app_spacing.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:greeting_app/data/domain/sticker_item.dart';
import 'package:greeting_app/viewmodels/greeting_card/greeting_card_view_model.dart';

class EditorTools extends StatelessWidget {
  final GreetingCardViewModel vm;
  final Function(BuildContext, GreetingCardViewModel) onAddSticker;
  final VoidCallback? onAskAi;

  const EditorTools({
    super.key,
    required this.vm,
    required this.onAddSticker,
    this.onAskAi,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final selectedSticker = vm.selectedStickerId != null
        ? vm.stickers.cast<StickerItem?>().firstWhere(
            (s) => s?.id == vm.selectedStickerId,
            orElse: () => null,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showBackgroundSourcePicker(context),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Ảnh nền"),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => onAddSticker(context, vm),
                  icon: const Icon(Icons.add_reaction),
                  label: const Text("Thêm Sticker"),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),
          Text('Mẫu nhanh theo chủ đề:', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<String>(
            value: vm.activeTemplateId,
            isExpanded: true,
            borderRadius: BorderRadius.circular(12),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              prefixIcon: const Icon(
                Icons.style_outlined,
                color: TetColors.prosperityGoldDark,
              ),
              filled: true,
              fillColor: TetColors.warmCream,
            ),
            hint: const Text('Chọn mẫu thiệp để áp dụng nhanh'),
            items: GreetingCardViewModel.templateLibrary
                .map(
                  (template) => DropdownMenuItem<String>(
                    value: template.id,
                    child: Text(template.title),
                  ),
                )
                .toList(),
            onChanged: (templateId) {
              if (templateId == null) return;
              final template = GreetingCardViewModel.templateLibrary.firstWhere(
                (item) => item.id == templateId,
              );
              vm.applyTemplate(template);
            },
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: selectedSticker == null
                ? const SizedBox.shrink()
                : Padding(
                    key: ValueKey(selectedSticker.id),
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: Column(
                      children: [
                        _buildScaleSlider(selectedSticker),
                        const SizedBox(height: AppSpacing.sm),
                        _buildRotationSlider(selectedSticker),
                      ],
                    ),
                  ),
          ),

          const SizedBox(height: AppSpacing.md),
          Autocomplete<String>(
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              // Lọc danh sách gợi ý dựa trên văn bản đã nhập
              return vm.suggestions.where(
                (s) => s.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                ),
              );
            },
            onSelected: (val) => vm.updateMessage(val),
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
                  if (textEditingController.text != vm.message) {
                    textEditingController.text = vm.message;
                  }
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: "Nội dung lời chúc",
                      prefixIcon: const Icon(Icons.edit_note),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: vm.isAiGenerating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.auto_awesome,
                                color: TetColors.prosperityGoldDark,
                              ),
                        onPressed: onAskAi,
                        tooltip: "Gợi ý lời chúc từ AI",
                      ),
                    ),
                    onChanged: (val) => vm.updateMessage(val),
                  );
                },
          ),
          const SizedBox(height: AppSpacing.lg),
          Text("Màu sắc lời chúc:", style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          _buildColorPicker(),
        ],
      ),
    );
  }

  Widget _buildScaleSlider(StickerItem sticker) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: TetColors.statusMessaged.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TetColors.statusMessaged.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          const Icon(Icons.zoom_in, size: 22, color: TetColors.statusMessaged),
          Expanded(
            child: Slider(
              value: sticker.scale,
              min: 0.5,
              max: 3.0,
              divisions: 25,
              onChanged: (val) => vm.updateStickerScale(val),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => vm.selectSticker(null),
          ),
        ],
      ),
    );
  }

  Widget _buildRotationSlider(StickerItem sticker) {
    final int degree = (sticker.rotation * 180 / math.pi).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: TetColors.deepOrange.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TetColors.deepOrange.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          const Icon(Icons.rotate_right, size: 22, color: TetColors.deepOrange),
          Expanded(
            child: Slider(
              value: sticker.rotation,
              min: -math.pi,
              max: math.pi,
              divisions: 72,
              onChanged: (val) => vm.updateStickerRotation(val),
            ),
          ),
          SizedBox(
            width: 46,
            child: Text(
              '$degree°',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.auto_awesome, color: TetColors.prosperityGoldDark),
      onSelected: (val) => vm.updateMessage(val),
      itemBuilder: (context) => vm.suggestions
          .map((s) => PopupMenuItem(value: s, child: Text(s)))
          .toList(),
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      TetColors.luckyRed,
      TetColors.prosperityGold,
      TetColors.deepOrange,
      TetColors.darkRed,
      TetColors.warmWhite,
      Colors.black,
      TetColors.statusCalled,
      TetColors.statusMessaged,
    ];
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          final isSelected = vm.textColor == color;
          return GestureDetector(
            onTap: () => vm.setTextColor(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 14),
              width: isSelected ? 42 : 35,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? TetColors.selectionHighlight
                      : TetColors.statusUnknown.withOpacity(0.35),
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: color == Colors.white
                          ? Colors.black
                          : Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  Future<void> _showBackgroundSourcePicker(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Chọn nguồn ảnh nền',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Lấy ảnh từ máy'),
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await _pickBackgroundFromDevice();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.wallpaper_outlined),
                  title: const Text('Lấy ảnh từ hệ thống'),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _showSystemBackgroundPicker(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickBackgroundFromDevice() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return;
    vm.setBackgroundImage(File(image.path));
  }

  Future<void> _showSystemBackgroundPicker(BuildContext context) async {
    final backgroundAssets =
        GreetingCardViewModel.templateLibrary
            .map((template) => template.backgroundAssetPath)
            .toSet()
            .toList()
          ..sort();

    if (backgroundAssets.isEmpty) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chọn ảnh nền hệ thống',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 250,
                  child: GridView.builder(
                    itemCount: backgroundAssets.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: AppSpacing.xs,
                          mainAxisSpacing: AppSpacing.xs,
                        ),
                    itemBuilder: (_, index) {
                      final assetPath = backgroundAssets[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          vm.setBackgroundAsset(assetPath);
                          Navigator.of(ctx).pop();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(assetPath, fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
