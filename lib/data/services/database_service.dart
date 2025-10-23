import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'users.db';
  static const int _databaseVersion = 1;

  static const String _usersTable = 'users';
  static const String _addressesTable = 'addresses';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<void> close() async {
    final db = await database;
    await db.close();
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_usersTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        birthDate TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $_addressesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        country TEXT NOT NULL,
        department TEXT NOT NULL,
        municipality TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES $_usersTable (id) ON DELETE CASCADE
      )
    ''');
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createTables,
    );
  }
}
