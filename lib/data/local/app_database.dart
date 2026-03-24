import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'greeting_app.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE contacts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT NOT NULL,
      relationshipType INTEGER NOT NULL,
      greetingStatus INTEGER NOT NULL DEFAULT 0,
      isPinned INTEGER NOT NULL DEFAULT 0
    )
  ''');

    await db.execute('''
    CREATE TABLE greeting_cards (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      backgroundPath TEXT NOT NULL,
      message TEXT NOT NULL,
      createdAt INTEGER NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE icons (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cardId INTEGER NOT NULL,
      iconPath TEXT NOT NULL,
      posX REAL NOT NULL,
      posY REAL NOT NULL,
      scale REAL NOT NULL,
      rotation REAL NOT NULL,
      FOREIGN KEY (cardId) REFERENCES greeting_cards(id)
        ON DELETE CASCADE
    )
  ''');

    await _createCustomStickerTable(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createCustomStickerTable(db);
    }

    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE contacts ADD COLUMN isPinned INTEGER NOT NULL DEFAULT 0',
      );
    }
  }

  Future<void> _createCustomStickerTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS custom_stickers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      localPath TEXT NOT NULL UNIQUE,
      name TEXT NOT NULL,
      createdAt INTEGER NOT NULL
    )
  ''');
  }
}
