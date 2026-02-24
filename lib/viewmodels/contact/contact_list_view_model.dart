import 'package:flutter/material.dart';
import 'package:greeting_app/data/domain/contact.dart';
import 'package:greeting_app/data/repositories/contact_repository.dart';

class ContactListViewModel extends ChangeNotifier {
  ContactListViewModel(this._repository);

  final ContactRepository _repository;

  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Lưu trữ trạng thái lọc hiện tại
  int? _currentRelationshipFilter;
  int? _currentGreetingStatusFilter;

  // Getter để UI có thể đồng bộ trạng thái
  int? get currentRelationshipFilter => _currentRelationshipFilter;
  int? get currentGreetingStatusFilter => _currentGreetingStatusFilter;

  // Hàm lọc chính: Chấp nhận cả 2 tham số
  Future<void> applyFilters({int? relationship, int? status}) async {
    try {
      _setLoading(true);
      _error = null;

      // Cập nhật trạng thái lọc (giữ lại giá trị cũ nếu truyền vào null không chủ đích)
      // Ở đây ta gán trực tiếp để hỗ trợ cả việc xóa filter (truyền null)
      _currentRelationshipFilter = relationship;
      _currentGreetingStatusFilter = status;

      // Gọi Repository với cả 2 tham số
      _contacts = await _repository.filterContacts(
        relationshipType: _currentRelationshipFilter,
        greetingStatus: _currentGreetingStatusFilter,
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Load all chỉ đơn giản là reset bộ lọc về null
  Future<void> loadAll() async {
    await applyFilters(relationship: null, status: null);
  }

  // Refresh sẽ giữ nguyên bộ lọc hiện tại
  Future<void> refresh() async {
    await applyFilters(
      relationship: _currentRelationshipFilter,
      status: _currentGreetingStatusFilter,
    );
  }

  Future<void> updateRelationshipType(Contact contact, int relationshipType) async {
    final id = contact.id;
    if (id == null) {
      throw Exception('Liên hệ không hợp lệ');
    }

    await _repository.updateRelationshipType(
      contactId: id,
      relationshipType: relationshipType,
    );

    await refresh();
  }

  Future<void> deleteContact(Contact contact) async {
    if (contact.id == null) {
      throw Exception('Liên hệ không hợp lệ');
    }

    await _repository.deleteContact(contact.id!);
    _contacts = List<Contact>.from(_contacts)
      ..removeWhere((c) => c.id == contact.id);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}