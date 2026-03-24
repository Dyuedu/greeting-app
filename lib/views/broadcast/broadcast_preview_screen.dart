import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/app_spacing.dart';
import 'package:greeting_app/core/theme/app_theme.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';
import 'package:greeting_app/core/widgets/animated_reveal.dart';
import 'package:greeting_app/core/widgets/edit_tools.dart';
import 'package:greeting_app/core/widgets/greeting_card_canvas.dart';
import 'package:greeting_app/core/widgets/sticker_picker_sheet.dart';
import 'package:greeting_app/data/repositories/contact_repository.dart';
import 'package:greeting_app/data/repositories/greeting_export_repository.dart';
import 'package:greeting_app/viewmodels/broadcast/broadcast_view_model.dart';
import 'package:greeting_app/viewmodels/greeting_card/greeting_card_view_model.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class BroadcastPreviewScreen extends StatefulWidget {
  const BroadcastPreviewScreen({super.key});

  @override
  State<BroadcastPreviewScreen> createState() => _BroadcastPreviewScreenState();
}

class _BroadcastPreviewScreenState extends State<BroadcastPreviewScreen> {
  late GreetingCardViewModel _cardViewModel;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    final exportRepo = context.read<GreetingExportRepository>();
    final contactRepo = context.read<ContactRepository>();
    _cardViewModel = GreetingCardViewModel(exportRepo, contactRepo);
  }

  @override
  void dispose() {
    _cardViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _cardViewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<BroadcastViewModel>(
            builder: (_, vm, __) =>
                Text('Thiệp cho ${vm.selectedContacts.length} liên hệ'),
          ),
          flexibleSpace: AppTheme.tetAppBarBackground,
          actions: [
            Consumer<BroadcastViewModel>(
              builder: (_, vm, __) => IconButton(
                icon: vm.isSharing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.share),
                tooltip: 'Chia sẻ thiệp',
                onPressed: vm.isSharing ? null : _handleShare,
              ),
            ),
          ],
        ),
        body: Consumer<BroadcastViewModel>(
          builder: (context, vm, _) {
            if (vm.selectedContacts.isEmpty) {
              return const Center(
                child: Text('Không có liên hệ nào được chọn.'),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedReveal(
                    delay: const Duration(milliseconds: 50),
                    beginOffset: const Offset(0, 0.04),
                    child: _buildSelectedContacts(vm),
                  ),
                  AnimatedReveal(
                    delay: const Duration(milliseconds: 130),
                    beginOffset: const Offset(0, 0.05),
                    child: _buildCardCanvas(),
                  ),
                  AnimatedReveal(
                    delay: const Duration(milliseconds: 210),
                    beginOffset: const Offset(0, 0.06),
                    child: _buildEditorTools(vm),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardCanvas() {
    return Consumer<GreetingCardViewModel>(
      builder: (context, vm, _) => Screenshot(
        controller: _screenshotController,
        child: GreetingCardCanvas(
          onDeleteRequest: (stickerId) => _showDeleteDialog(vm, stickerId),
        ),
      ),
    );
  }

  Widget _buildEditorTools(BroadcastViewModel vm) {
    return Consumer<GreetingCardViewModel>(
      builder: (context, cardVm, _) => EditorTools(
        vm: cardVm,
        onAddSticker: _showStickerPicker,
        onAskAi: vm.selectedContacts.isEmpty
            ? null
            : () => cardVm.generateAIWish(
                vm.selectedContacts.first.name,
                vm.selectedContacts.first.relationshipType,
              ),
      ),
    );
  }

  Widget _buildSelectedContacts(BroadcastViewModel vm) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Người nhận (${vm.selectedContacts.length})',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: vm.selectedContacts
                .asMap()
                .entries
                .map(
                  (entry) => AnimatedReveal(
                    delay: Duration(
                      milliseconds: 40 * (entry.key > 8 ? 8 : entry.key),
                    ),
                    beginOffset: const Offset(0, 0.03),
                    duration: const Duration(milliseconds: 360),
                    child: Chip(
                      label: Text(
                        entry.value.name,
                        style: textTheme.labelMedium,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(GreetingCardViewModel vm, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa nhãn dán?'),
        content: const Text('Bạn có muốn gỡ bỏ sticker này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              vm.removeSticker(id);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: TetColors.actionDelete),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleShare() async {
    final broadcastVm = context.read<BroadcastViewModel>();
    final cardVm = _cardViewModel;

    cardVm.selectSticker(null);
    final status = await broadcastVm.shareCard(_screenshotController);

    if (!mounted) return;

    if (status == ShareResultStatus.success) {
      _showConfirmationDialog(broadcastVm);
    } else if (status == ShareResultStatus.unavailable) {
      _showError('Không thể mở bảng chia sẻ trên thiết bị này.');
    } else if (status == null) {
      _showError('Không thể chụp ảnh thiệp.');
    }
  }

  void _showConfirmationDialog(BroadcastViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cập nhật trạng thái?'),
        content: Text(
          'Bạn đã gửi thiệp thành công cho ${vm.selectedContacts.length} liên hệ chưa?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              await vm.markAllAsSent();
              if (!mounted) return;
              Navigator.pop(ctx);
              Navigator.of(context).pop(true);
            },
            child: const Text(
              'Đã gửi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showStickerPicker(BuildContext context, GreetingCardViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StickerPickerSheet(cardViewModel: vm),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
