import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/app_theme.dart';
import 'package:greeting_app/core/theme/app_spacing.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';
import 'package:greeting_app/core/widgets/animated_reveal.dart';
import 'package:greeting_app/core/widgets/contact_filter_drawer.dart';
import 'package:greeting_app/data/domain/contact.dart';
import 'package:greeting_app/viewmodels/contact/contact_list_view_model.dart';
import 'package:greeting_app/views/broadcast/broadcast_contact_select_screen.dart';
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lý lời chúc Tết',
          style: textTheme.titleLarge?.copyWith(color: Colors.yellowAccent),
        ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => const BroadcastContactSelectScreen(),
            ),
          );

          if (result == true && mounted) {
            await context.read<ContactListViewModel>().refresh();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã cập nhật trạng thái gửi hàng loạt.'),
              ),
            );
          }
        },
        icon: const Icon(Icons.send),
        label: Text('Gửi hàng loạt', style: textTheme.labelLarge),
      ),
    );
  }

  Widget _buildBody(ContactListViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null) {
      return Center(
        child: Text(
          'Lỗi: ${vm.error}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    if (vm.contacts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Text('Chưa có liên hệ nào, hãy nhập danh bạ để bắt đầu.'),
        ),
      );
    }

    return ListView.separated(
      itemCount: vm.contacts.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final contact = vm.contacts[index];

        return AnimatedReveal(
          delay: Duration(milliseconds: 25 * (index > 12 ? 12 : index)),
          beginOffset: const Offset(0, 0.05),
          child: ListTile(
            leading: IconButton(
              icon: Icon(
                contact.isPinned
                    ? Icons.push_pin_rounded
                    : Icons.push_pin_outlined,
                color: contact.isPinned
                    ? TetColors.prosperityGoldDark
                    : TetColors.statusUnknown,
                size: 22,
              ),
              tooltip: contact.isPinned
                  ? 'Bỏ ghim liên hệ'
                  : 'Đánh dấu quan trọng',
              onPressed: () => _togglePinned(contact),
            ),
            title: Text(
              contact.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              _buildSubtitle(contact),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cố định kích thước cho nút Edit
                SizedBox(
                  width: 40,
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: TetColors.actionEdit,
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
                      color: TetColors.actionDelete,
                      size: 22,
                    ),
                    tooltip: 'Xóa liên hệ',
                    onPressed: () => _confirmDelete(contact),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                // Quan trọng nhất: Cố định không gian cho Chip
                SizedBox(
                  width: 98,
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
          ),
        );
      },
    );
  }

  String _buildSubtitle(Contact contact) {
    final relationship = _relationshipLabel(contact.relationshipType);

    return '${contact.phone} · $relationship';
  }

  Widget _buildStatusChip(Contact contact) {
    final (label, color, icon) = switch (contact.greetingStatus) {
      0 => ('Chưa gửi', TetColors.statusPending, Icons.schedule_rounded),
      1 => ('Đã gọi', TetColors.statusCalled, Icons.phone_in_talk_rounded),
      2 => ('Đã nhắn', TetColors.statusMessaged, Icons.mark_chat_read_rounded),
      _ => ('Không rõ', TetColors.statusUnknown, Icons.help_outline_rounded),
    };

    return Chip(
      avatar: Icon(icon, size: 14, color: color),
      label: SizedBox(
        width: 60,
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: color.withOpacity(0.14),
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
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text(
                  'Chọn mối quan hệ',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
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
              const SizedBox(height: AppSpacing.xs),
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
                  backgroundColor: TetColors.actionDelete,
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

  Future<void> _togglePinned(Contact contact) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.read<ContactListViewModel>().togglePinned(contact);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            contact.isPinned
                ? 'Đã bỏ ghim ${contact.name}'
                : 'Đã ghim ${contact.name} lên đầu',
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Cập nhật ghim thất bại: $e')),
      );
    }
  }
}
