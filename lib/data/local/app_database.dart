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

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE contacts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT NOT NULL,
      relationshipType INTEGER NOT NULL,
      greetingStatus INTEGER NOT NULL DEFAULT 0
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
  }
}
