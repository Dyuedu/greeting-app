import 'package:flutter/foundation.dart';
import 'package:greeting_app/data/domain/contact.dart';
import '../../data/repositories/contact_repository.dart';

class ContactImportViewModel extends ChangeNotifier {
  ContactImportViewModel(this._repository);

  final ContactRepository _repository;

  /// Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Error message
  String? _error;
  String? get error => _error;

  /// Normalized phone numbers of already imported contacts
  Future<Set<String>> getImportedPhoneNumbers() async {
    try {
      _setLoading(true);

      final existing = await _repository.getAllContacts();

      return existing
          .map((c) => _normalizePhone(c.phone))
          .toSet();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {};
    } finally {
      _setLoading(false);
    }
  }

  /// Import selected contacts
  Future<void> importContacts({
    required List<({String name, String phone})> contacts,
    required int relationshipType,
  }) async {
    if (contacts.isEmpty) return;

    try {
      _setLoading(true);
      _error = null;

      final entities = contacts
          .map(
            (contact) => Contact(
              name: contact.name,
              phone: contact.phone,
              relationshipType: relationshipType,
              greetingStatus: 0, // Pending
            ),
          )
          .toList();

      await _repository.insertContacts(entities);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ==============================
  // Helpers
  // ==============================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _normalizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }
}
