import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/app_theme.dart';
import 'package:greeting_app/core/widgets/contact_filter_drawer.dart';
import 'package:greeting_app/data/domain/contact.dart';
import 'package:greeting_app/viewmodels/contact/contact_list_view_model.dart';
import 'package:greeting_app/views/contact_import_screen.dart';
import 'package:greeting_app/views/greeting_detail_screen.dart';
import 'package:provider/provider.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  int? _statusFilter;
  int? _relationshipFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ContactListViewModel>().loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ContactListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý lời chúc Tết'),
        flexibleSpace: AppTheme.tetAppBarBackground,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Nhập danh bạ',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ContactImportScreen()),
              );
              // Sau khi quay về, tự động reload lại danh bạ để cập nhật những contact mới được thêm
              if (mounted) {
                context
                    .read<ContactListViewModel>()
                    .refresh(); // Kích hoạt notifyListeners để cập nhật giao diện
              }
            },
          ),
        ],
      ),
      endDrawer: ContactFilterDrawer(
        currentStatus: _statusFilter,
        currentRelationship: _relationshipFilter,
        onStatusChanged: (val) async {
          setState(() {
            _statusFilter = val; // Cập nhật giá trị mới cho status
          });
          // Gọi hàm lọc chung với cả 2 tham số hiện tại
          await vm.applyFilters(
            status: _statusFilter,
            relationship: _relationshipFilter,
          );
        },
        onRelationshipChanged: (val) async {
          setState(() {
            _relationshipFilter = val; // Cập nhật giá trị mới cho relationship
          });
          // Gọi hàm lọc chung với cả 2 tham số hiện tại
          await vm.applyFilters(
            status: _statusFilter,
            relationship: _relationshipFilter,
          );
        },
        onReset: () async {
          setState(() {
            _statusFilter = null;
            _relationshipFilter = null;
          });
          await vm.loadAll();
        },
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(ContactListViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null) {
      return Center(child: Text('Lỗi: ${vm.error}'));
    }

    if (vm.contacts.isEmpty) {
      return const Center(
        child: Text('Chưa có liên hệ nào, hãy nhập danh bạ để bắt đầu.'),
      );
    }

    return ListView.separated(
      itemCount: vm.contacts.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final contact = vm.contacts[index];

        return ListTile(
          title: Text(contact.name),
          subtitle: Text(_buildSubtitle(contact)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cố định kích thước cho nút Edit
              SizedBox(
                width: 40,
                child: IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.teal,
                    size: 22,
                  ),
                  tooltip: 'Sửa mối quan hệ',
                  onPressed: () => _editRelationship(contact),
                  padding:
                      EdgeInsets.zero, // Giảm padding để tiết kiệm không gian
                ),
              ),
              // Cố định kích thước cho nút Delete
              SizedBox(
                width: 40,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                  tooltip: 'Xóa liên hệ',
                  onPressed: () => _confirmDelete(contact),
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 4),
              // Quan trọng nhất: Cố định không gian cho Chip
              SizedBox(
                width: 90, // Khoảng cách đủ rộng cho chữ dài nhất ("Chưa gửi")
                child: Center(child: _buildStatusChip(contact)),
              ),
            ],
          ),
          onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => GreetingDetailScreen(contact: contact),
              ),
            );
            if (result == true) {
              context.read<ContactListViewModel>().refresh();
            }
          },
        );
      },
    );
  }

  String _buildSubtitle(Contact contact) {
    final relationship = _relationshipLabel(contact.relationshipType);

    return '${contact.phone} · $relationship';
  }

  Widget _buildStatusChip(Contact contact) {
    final (label, color) = switch (contact.greetingStatus) {
      0 => ('Chưa gửi', Colors.orange),
      1 => ('Đã gọi', Colors.green),
      2 => ('Đã nhắn', Colors.blue),
      _ => ('Không rõ', Colors.grey),
    };

    return Chip(
      label: Container(
        width: 60, // Cố định chiều rộng của text bên trong chip
        height: 20, // Cố định chiều cao của chip
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 12),
          overflow: TextOverflow.ellipsis, // Đề phòng trường hợp chữ quá dài
        ),
      ),
      backgroundColor: color.withOpacity(0.12),
      padding: EdgeInsets.zero,
      materialTapTargetSize:
          MaterialTapTargetSize.shrinkWrap, // Giảm khoảng cách thừa
    );
  }

  String _relationshipLabel(int type) {
    return switch (type) {
      0 => 'Gia đình',
      1 => 'Sếp',
      2 => 'Bạn bè',
      3 => 'Đồng nghiệp',
      _ => 'Không rõ',
    };
  }

  Future<void> _editRelationship(Contact contact) async {
    final selectedType = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        final options = [0, 1, 2, 3];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Chọn mối quan hệ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              ...options.map(
                (type) => RadioListTile<int>(
                  value: type,
                  groupValue: contact.relationshipType,
                  title: Text(_relationshipLabel(type)),
                  onChanged: (val) => Navigator.of(context).pop(val),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!mounted ||
        selectedType == null ||
        selectedType == contact.relationshipType)
      return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.read<ContactListViewModel>().updateRelationshipType(
        contact,
        selectedType,
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Đã chuyển ${contact.name} sang nhóm ${_relationshipLabel(selectedType)}',
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Cập nhật thất bại: $e')));
    }
  }

  Future<void> _confirmDelete(Contact contact) async {
    final shouldDelete =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xóa liên hệ?'),
            content: Text('Bạn chắc chắn muốn xóa ${contact.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('HỦY'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text('XÓA'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.read<ContactListViewModel>().deleteContact(contact);
      messenger.showSnackBar(SnackBar(content: Text('Đã xóa ${contact.name}')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Xóa thất bại: $e')));
    }
  }
}
