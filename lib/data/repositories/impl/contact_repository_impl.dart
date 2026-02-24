import 'package:greeting_app/data/domain/contact.dart';
import 'package:greeting_app/data/local/daos/contact_dao.dart';
import 'package:greeting_app/data/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactDao _dao;

  ContactRepositoryImpl(this._dao);

  @override
  Future<List<Contact>> getAllContacts() {
    return _dao.getAllContacts();
  }

  @override
  Future<void> insertContact(Contact contact) async {
    await _dao.insertContact(contact);
  }

  @override
  Future<void> insertContacts(List<Contact> contacts) async {
    await _dao.insertContacts(contacts);
  }

  @override
  Future<void> updateGreetingStatus({
    int? contactId,
    required int greetingStatus,
  }) async {
    await _dao.updateGreetingStatus(
      contactId: contactId,
      greetingStatus: greetingStatus,
    );
  }

  @override
  Future<void> updateRelationshipType({
    required int contactId,
    required int relationshipType,
  }) async {
    await _dao.updateRelationshipType(
      contactId: contactId,
      relationshipType: relationshipType,
    );
  }

  @override
  Future<void> deleteContact(int id) async {
    await _dao.deleteContact(id);
  }

  @override
  Future<List<Contact>> getByRelationshipType(int type) {
    return _dao.getContactsByRelationshipType(type);
  }

  @override
  Future<List<Contact>> getByGreetingStatus(int status) {
    return _dao.getContactsByGreetingStatus(status);
  }

  @override
  Future<List<Contact>> filterContacts({
    int? relationshipType,
    int? greetingStatus,
  }) {
    return _dao.getFilteredContacts(
      relationshipType: relationshipType,
      greetingStatus: greetingStatus,
    );
  }
}
