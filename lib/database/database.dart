import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  late Database _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'your_database.db');

    _database = await openDatabase(path, version: 1, onCreate: _createTables);
    return _database;
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');
  }

  Future<void> insertUser(String username, String password) async {
    final db = await database;

    await db.insert(
      'users',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> validateUser(String username, String password) async {
    final db = await database;

    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }
}
