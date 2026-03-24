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

    final result = await db.query(
      'contacts',
      orderBy: 'isPinned DESC, name COLLATE NOCASE ASC',
    );

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
      orderBy: 'isPinned DESC, name COLLATE NOCASE ASC',
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
      orderBy: 'isPinned DESC, name COLLATE NOCASE ASC',
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
      orderBy: 'isPinned DESC, name COLLATE NOCASE ASC',
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

  Future<void> updateGreetingStatusForMany({
    required List<int> contactIds,
    required int greetingStatus,
  }) async {
    if (contactIds.isEmpty) return;

    final db = await _dbHelper.database;
    final batch = db.batch();

    for (final id in contactIds) {
      batch.update(
        'contacts',
        {'greetingStatus': greetingStatus},
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    await batch.commit(noResult: true);
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

  Future<int> updatePinnedStatus({
    required int contactId,
    required bool isPinned,
  }) async {
    final db = await _dbHelper.database;

    return db.update(
      'contacts',
      {'isPinned': isPinned ? 1 : 0},
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
