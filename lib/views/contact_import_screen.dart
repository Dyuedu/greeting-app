import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:greeting_app/core/theme/app_theme.dart';
import 'package:greeting_app/viewmodels/contact/contact_import_view_model.dart';
import 'package:provider/provider.dart';

class ContactImportScreen extends StatefulWidget {
  const ContactImportScreen({super.key});

  @override
  State<ContactImportScreen> createState() => _ContactImportScreenState();
}

class _ContactImportScreenState extends State<ContactImportScreen> {
  List<Contact> _allContacts = [];
  Set<String> _selectedContactIds = {};
  bool _isLoading = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoadContacts();
  }

  Future<void> _requestPermissionAndLoadContacts() async {
    setState(() => _isLoading = true);

    try {
      final hasPermission = await FlutterContacts.requestPermission();

      if (!hasPermission) {
        setState(() {
          _hasPermission = false;
          _isLoading = false;
        });
        return;
      }

      // 1. Lấy danh bạ từ máy
      final contacts = await FlutterContacts.getContacts(withProperties: true);

      // 2. Lấy danh sách SĐT đã có trong database từ ViewModel
      final vm = context.read<ContactImportViewModel>();
      final importedPhones = await vm.getImportedPhoneNumbers();

      // 3. Lọc: Chỉ giữ lại những contact có SĐT và CHƯA tồn tại trong importedPhones
      final filteredContacts = contacts.where((contact) {
        if (contact.phones.isEmpty) return false;

        // Chuẩn hóa số điện thoại để so sánh chính xác
        final rawPhone = contact.phones.first.number;
        final normalized = rawPhone.replaceAll(RegExp(r'[^\d+]'), '');

        // Nếu SĐT đã được nhập rồi thì loại bỏ (return false)
        return !importedPhones.contains(normalized);
      }).toList();

      setState(() {
        _hasPermission = true;
        _allContacts =
            filteredContacts; // Danh sách mới chỉ chứa liên hệ chưa nhập
        _selectedContactIds = {}; // Reset lại lựa chọn vì danh sách đã thay đổi
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi tải danh bạ: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleSelection(String contactId) {
    setState(() {
      if (_selectedContactIds.contains(contactId)) {
        _selectedContactIds.remove(contactId);
      } else {
        _selectedContactIds.add(contactId);
      }
    });
  }

  Future<void> _showRelationshipTypeDialog() async {
    if (_selectedContactIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất một liên hệ')),
      );
      return;
    }

    final relationshipType = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gán loại quan hệ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Đã chọn ${_selectedContactIds.length} liên hệ'),
            const SizedBox(height: 16),
            ...[
              ('Gia đình', 0),
              ('Sếp', 1),
              ('Bạn bè', 2),
              ('Đồng nghiệp', 3),
            ].map(
              (e) => ListTile(
                title: Text(e.$1),
                leading: Radio<int>(
                  value: e.$2,
                  groupValue: null,
                  onChanged: (_) => Navigator.pop(context, e.$2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );

    if (relationshipType != null) {
      await _importContacts(relationshipType);
    }
  }

  Future<void> _importContacts(int relationshipType) async {
    final selectedContacts = _allContacts
        .where((c) => _selectedContactIds.contains(c.id))
        .toList();

    final contactsToImport = selectedContacts
        .map(
          (c) => (
            name: c.displayName,
            phone: c.phones.first.number.replaceAll(RegExp(r'[^\d+]'), ''),
          ),
        )
        .toList();

    setState(() => _isLoading = true);

    try {
      final vm = context.read<ContactImportViewModel>();

      await vm.importContacts(
        contacts: contactsToImport,
        relationshipType: relationshipType,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã lưu thành công ${contactsToImport.length} liên hệ'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi nhập danh bạ: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ContactImportViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập danh bạ'),
        flexibleSpace: AppTheme.tetAppBarBackground,
        actions: [
          if (_selectedContactIds.isNotEmpty)
            TextButton(
              onPressed: _isLoading ? null : _showRelationshipTypeDialog,
              child: Text(
                'Nhập (${_selectedContactIds.length})',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _selectedContactIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _isLoading ? null : _showRelationshipTypeDialog,
              icon: const Icon(Icons.save),
              label: Text('Nhập (${_selectedContactIds.length})'),
            )
          : null,
      body: (_isLoading || vm.isLoading)
          ? const Center(child: CircularProgressIndicator())
          : !_hasPermission
          ? _buildPermissionView()
          : _buildContactList(),
    );
  }

  Widget _buildPermissionView() {
    return Center(
      child: ElevatedButton(
        onPressed: _requestPermissionAndLoadContacts,
        child: const Text('Cấp quyền truy cập'),
      ),
    );
  }

  Widget _buildContactList() {
    if (_allContacts.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy liên hệ nào có số điện thoại'),
      );
    }

    return ListView.builder(
      itemCount: _allContacts.length,
      itemBuilder: (context, index) {
        final contact = _allContacts[index];
        final isSelected = _selectedContactIds.contains(contact.id);

        return CheckboxListTile(
          value: isSelected,
          onChanged: (_) => _toggleSelection(contact.id),
          title: Text(contact.displayName),
          subtitle: Text(contact.phones.first.number),
        );
      },
    );
  }
}
