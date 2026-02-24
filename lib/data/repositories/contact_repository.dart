import 'package:greeting_app/data/domain/contact.dart';

abstract class ContactRepository {
  Future<List<Contact>> getAllContacts();

  Future<void> insertContact(Contact contact);

  Future<void> insertContacts(List<Contact> contacts);

  Future<void> updateGreetingStatus({
    int? contactId,
    required int greetingStatus,
  });

  Future<void> updateRelationshipType({
    required int contactId,
    required int relationshipType,
  });

  Future<void> deleteContact(int id);

  Future<List<Contact>> getByRelationshipType(int type);

  Future<List<Contact>> getByGreetingStatus(int status);

  Future<List<Contact>> filterContacts({
     int? relationshipType,
     int? greetingStatus,
  });
}
