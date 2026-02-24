import 'package:greeting_app/data/domain/contact.dart';
import 'package:greeting_app/data/local/app_database.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {
  final AppDatabase _dbHelper = AppDatabase.instance;

  /// INSERT ONE
  Future<int> insertContact(Contact contact) async {
    final db = await _dbHelper.database;

    return db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// INSERT MANY (BATCH)
  Future<void> insertContacts(List<Contact> contacts) async {
    final db = await _dbHelper.database;

    final batch = db.batch();

    for (final contact in contacts) {
      batch.insert(
        'contacts',
        contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// GET ALL
  Future<List<Contact>> getAllContacts() async {
    final db = await _dbHelper.database;

    final result = await db.query('contacts');

    return result.map((e) => Contact.fromMap(e)).toList();
  }

  /// GET BY RELATIONSHIP TYPE
  Future<List<Contact>> getContactsByRelationshipType(
    int relationshipType,
  ) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'contacts',
      where: 'relationshipType = ?',
      whereArgs: [relationshipType],
    );

    return result.map((e) => Contact.fromMap(e)).toList();
  }

  Future<List<Contact>> getFilteredContacts({
    int? relationshipType,
    int? greetingStatus,
  }) async {
    final db = await _dbHelper.database;

    List<String> conditions = [];
    List<dynamic> args = [];

    if (relationshipType != null) {
      conditions.add('relationshipType = ?');
      args.add(relationshipType);
    }

    if (greetingStatus != null) {
      conditions.add('greetingStatus = ?');
      args.add(greetingStatus);
    }

    final result = await db.query(
      'contacts',
      where: conditions.isEmpty ? null : conditions.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
    );

    return result.map((e) => Contact.fromMap(e)).toList();
  }

  /// GET BY GREETING STATUS
  Future<List<Contact>> getContactsByGreetingStatus(int greetingStatus) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'contacts',
      where: 'greetingStatus = ?',
      whereArgs: [greetingStatus],
    );

    return result.map((e) => Contact.fromMap(e)).toList();
  }

  /// UPDATE GREETING STATUS
  Future<int> updateGreetingStatus({
    int? contactId,
    required int greetingStatus,
  }) async {
    final db = await _dbHelper.database;

    return db.update(
      'contacts',
      {'greetingStatus': greetingStatus},
      where: 'id = ?',
      whereArgs: [contactId],
    );
  }

  Future<int> updateRelationshipType({
    required int contactId,
    required int relationshipType,
  }) async {
    final db = await _dbHelper.database;

    return db.update(
      'contacts',
      {'relationshipType': relationshipType},
      where: 'id = ?',
      whereArgs: [contactId],
    );
  }

  /// DELETE
  Future<int> deleteContact(int id) async {
    final db = await _dbHelper.database;

    return db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
