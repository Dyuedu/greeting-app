import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/app_theme.dart';
import 'package:greeting_app/core/widgets/contact_footer.dart';
import 'package:greeting_app/core/widgets/edit_tools.dart';
import 'package:greeting_app/core/widgets/greeting_card_canvas.dart';
import 'package:greeting_app/data/repositories/contact_repository.dart';
import 'package:greeting_app/data/repositories/greeting_export_repository.dart';
import 'package:greeting_app/viewmodels/greeting_card/greeting_card_view_model.dart';
import 'package:provider/provider.dart';
import 'package:greeting_app/data/domain/contact.dart';
import 'package:screenshot/screenshot.dart';

class GreetingDetailScreen extends StatefulWidget {
  final Contact contact;

  const GreetingDetailScreen({super.key, required this.contact});

  @override
  State<GreetingDetailScreen> createState() => _GreetingDetailScreenState();
}

class _GreetingDetailScreenState extends State<GreetingDetailScreen> {
  late GreetingCardViewModel _viewModel;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    final exportRepo = context.read<GreetingExportRepository>();
    final contactRepo = context.read<ContactRepository>();
    _viewModel = GreetingCardViewModel(exportRepo, contactRepo);
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng .value với instance được quản lý bởi State để tránh bị khởi tạo lại
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thiết kế thiệp cho ${widget.contact.name}'),
          flexibleSpace: AppTheme.tetAppBarBackground,
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _handleShare,
              tooltip: "Chia sẻ trực tiếp",
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildCardCanvas(),
              _buildEditorTools(),
              _buildContactFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardCanvas() {
    return Screenshot(
      controller: _screenshotController,
      child: GreetingCardCanvas(
        onDeleteRequest: (stickerId) {
          _showDeleteDialog(context, _viewModel, stickerId);
        },
      ),
    );
  }

  // Hàm phụ hiển thị xác nhận xóa sticker
  void _showDeleteDialog(
    BuildContext context,
    GreetingCardViewModel vm,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xóa nhãn dán?"),
        content: const Text("Bạn có muốn gỡ bỏ sticker này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              vm.removeSticker(id);
              Navigator.pop(ctx);
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 2. BỘ CÔNG CỤ ĐIỀU KHIỂN
  Widget _buildEditorTools() {
    return Consumer<GreetingCardViewModel>(
      builder: (context, vm, _) =>
          EditorTools(vm: vm, onAddSticker: _showStickerPicker),
    );
  }

  // 3. THÔNG TIN LIÊN HỆ & NÚT LƯU
  Widget _buildContactFooter() {
    return ContactFooter(
      contact: widget.contact,
      onSave: _handleSave,
      onCall: _handleCall,
    );
  }

  // Bottom Sheet chọn Sticker
  void _showStickerPicker(BuildContext context, GreetingCardViewModel vm) {
    
    final List<String> myStickers = [
      'assets/stickers/hoamai.png',
      'assets/stickers/lixi.png',
      'assets/stickers/sticker1.png',
      'assets/stickers/sticker2.png',
      'assets/stickers/sticker3.png',
      'assets/stickers/sticker4.png',
      'assets/stickers/sticker5.png',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemCount: myStickers.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            vm.addSticker(myStickers[index]);
            Navigator.pop(context);
          },
          child: Image.asset(myStickers[index]),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    // 1. Hiện Loading (có thể dùng Dialog hoặc Overlay)
    _showLoading();

    try {
      // 2. Gọi ViewModel thực hiện (ViewModel sẽ gọi Repository)
      await _viewModel.exportAndSave(_screenshotController);

      if (!mounted) return;
      Navigator.pop(context); // Đóng loading

      // 3. Thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✨ Đã lưu thiệp vào thư viện ảnh!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Đóng loading

      // 4. Thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi lưu: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _handleShare() async {
    final bool isShared = await _viewModel.exportAndShare(
      _screenshotController,
      widget.contact.id,
    );

    if (isShared && mounted) {
      _showUpdateStatusDialog();
    }
  }

  void _showUpdateStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cập nhật trạng thái?"),
        content: const Text("Bạn đã gửi tin nhắn thành công chưa?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              await _viewModel.updateContactGreetingStatus(contactId: widget.contact.id, status: 2);
              if (mounted) {
                Navigator.pop(ctx);
                Navigator.of(context).pop(true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã cập nhật trạng thái!")),
                );
              }
            },
            child: const Text(
              "Đã gửi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCall() async {
    // Gọi hàm từ ViewModel
    final bool isDialed = await _viewModel.makePhoneCall(widget.contact.phone);

    if (isDialed && mounted) {
      // Hiển thị Dialog hỏi xem đã chúc Tết thành công chưa
      _showCallUpdateStatusDialog();
    }
  }

  void _showCallUpdateStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cập nhật trạng thái?"),
        content: const Text("Bạn đã gọi điện chúc Tết thành công chưa?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              // Cập nhật status = 1 (Đã gọi)
              await _viewModel.updateContactGreetingStatus(
                contactId: widget.contact.id,
                status: 1,
              );
              if (mounted) {
                Navigator.pop(ctx);
                Navigator.of(
                  context,
                ).pop(true); // Quay lại danh sách và refresh
              }
            },
            child: const Text(
              "Đã gọi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
