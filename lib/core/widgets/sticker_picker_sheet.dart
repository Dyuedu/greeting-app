import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';
import 'package:greeting_app/data/domain/custom_sticker.dart';
import 'package:greeting_app/viewmodels/greeting_card/greeting_card_view_model.dart';
import 'package:greeting_app/viewmodels/sticker/custom_sticker_view_model.dart';
import 'package:provider/provider.dart';

class StickerPickerSheet extends StatefulWidget {
  final GreetingCardViewModel cardViewModel;

  const StickerPickerSheet({super.key, required this.cardViewModel});

  @override
  State<StickerPickerSheet> createState() => _StickerPickerSheetState();
}

class _StickerPickerSheetState extends State<StickerPickerSheet> {
  static const List<String> _defaultStickers = [
    'assets/stickers/hoamai.png',
    'assets/stickers/lixi.png',
    'assets/stickers/sticker1.png',
    'assets/stickers/sticker2.png',
    'assets/stickers/sticker3.png',
    'assets/stickers/sticker4.png',
    'assets/stickers/sticker5.png',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomStickerViewModel>().loadStickers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
        height: 480,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Mặc định'),
                Tab(text: 'Của tôi'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [_buildDefaultTab(), _buildCustomTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemCount: _defaultStickers.length,
      itemBuilder: (context, index) {
        final path = _defaultStickers[index];
        return GestureDetector(
          onTap: () => _selectSticker(path),
          child: Container(
            decoration: BoxDecoration(
              color: TetColors.warmWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TetColors.prosperityGold.withOpacity(0.3),
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(path),
          ),
        );
      },
    );
  }

  Widget _buildCustomTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer<CustomStickerViewModel>(
        builder: (context, vm, _) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _handleUpload(vm),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Upload ảnh'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _handleImport(vm),
                      icon: const Icon(Icons.table_view_outlined),
                      label: const Text('Import CSV'),
                    ),
                  ),
                ],
              ),
              if (vm.isLoading) ...[
                const SizedBox(height: 12),
                const LinearProgressIndicator(),
              ],
              if (vm.error != null && vm.error!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  vm.error!,
                  style: const TextStyle(
                    color: TetColors.actionDelete,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Expanded(
                child: vm.stickers.isEmpty && !vm.isLoading
                    ? const Center(child: Text('Chưa có sticker nào'))
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                        itemCount: vm.stickers.length,
                        itemBuilder: (context, index) {
                          final sticker = vm.stickers[index];
                          return _CustomStickerTile(
                            sticker: sticker,
                            onTap: () => _selectSticker(sticker.localPath),
                            onDelete: () => _confirmDelete(vm, sticker),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _selectSticker(String path) {
    widget.cardViewModel.addSticker(path);
    Navigator.of(context).pop();
  }

  Future<void> _handleUpload(CustomStickerViewModel vm) async {
    try {
      await vm.uploadImage();
    } catch (e) {
      _showSnackBar('Không thể upload sticker: $e');
    }
  }

  Future<void> _handleImport(CustomStickerViewModel vm) async {
    try {
      await vm.importFromCsv();
    } catch (e) {
      _showSnackBar('Không thể import CSV: $e');
    }
  }

  Future<void> _confirmDelete(
    CustomStickerViewModel vm,
    CustomSticker sticker,
  ) async {
    final shouldDelete =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Xóa sticker?'),
            content: Text('Bạn có chắc muốn xóa ${sticker.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Xóa'),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldDelete && sticker.id != null) {
      try {
        await vm.deleteSticker(sticker.id!);
      } catch (e) {
        _showSnackBar('Không thể xóa sticker: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CustomStickerTile extends StatelessWidget {
  final CustomSticker sticker;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CustomStickerTile({
    required this.sticker,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onDelete,
      child: Container(
        decoration: BoxDecoration(
          color: TetColors.warmWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TetColors.prosperityGold.withOpacity(0.3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.file(
          File(sticker.localPath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.broken_image));
          },
        ),
      ),
    );
  }
}
