import 'package:flutter/material.dart';
import 'package:greeting_app/data/domain/contact.dart';
import 'package:greeting_app/data/repositories/contact_repository.dart';
import 'package:greeting_app/data/repositories/greeting_export_repository.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class BroadcastViewModel extends ChangeNotifier {
  BroadcastViewModel(this._contactRepository, this._exportRepository);

  final ContactRepository _contactRepository;
  final GreetingExportRepository _exportRepository;

  final List<Contact> _selectedContacts = [];
  List<Contact> get selectedContacts => List.unmodifiable(_selectedContacts);

  bool _isSharing = false;
  bool get isSharing => _isSharing;

  void toggleContact(Contact contact) {
    final id = contact.id;
    if (id == null) return;

    final exists = _selectedContacts.any((c) => c.id == id);
    if (exists) {
      _selectedContacts.removeWhere((c) => c.id == id);
    } else {
      _selectedContacts.add(contact);
    }
    notifyListeners();
  }

  bool isSelected(Contact contact) {
    final id = contact.id;
    if (id == null) return false;
    return _selectedContacts.any((c) => c.id == id);
  }

  void clearSelection() {
    if (_selectedContacts.isEmpty) return;
    _selectedContacts.clear();
    notifyListeners();
  }

  Future<ShareResultStatus?> shareCard(
    ScreenshotController controller,
  ) async {
    try {
      _isSharing = true;
      notifyListeners();

      final bytes = await _exportRepository.captureCard(controller);
      if (bytes == null) return null;

      final result = await _exportRepository.shareCard(
        bytes,
        'Chúc mừng năm mới',
      );

      return result.status;
    } finally {
      _isSharing = false;
      notifyListeners();
    }
  }

  Future<void> markAllAsSent() async {
    final ids = _selectedContacts.map((c) => c.id).whereType<int>().toList();
    if (ids.isEmpty) return;

    await _contactRepository.updateGreetingStatusForMany(
      contactIds: ids,
      greetingStatus: 2,
    );
    clearSelection();
  }
}
