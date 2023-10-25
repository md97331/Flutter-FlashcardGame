import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseProvider {
  static const String _databaseName = "flashcards.db";
  static const int _databaseVersion = 1;

  DatabaseProvider._();

  static final DatabaseProvider _singleton = DatabaseProvider._();

  factory DatabaseProvider() => _singleton;

  static Database? _database;

  get database async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var dbDir = await getDatabasesPath();
    var dbPath = path.join(dbDir, _databaseName);
    print(dbPath);

    var db = await openDatabase(dbPath, version: _databaseVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE decks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT
      )''');

      await db.execute('''CREATE TABLE flashcards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT,
        answer TEXT,
        deck_id INTEGER,
        FOREIGN KEY (deck_id) REFERENCES decks(id)
      )''');
    });

    return db;
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where}) async {
    final db = await this.database;
    return where == null ? db.query(table) : db.query(table, where: where);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await this.database;
    int id = await db.insert(
      table,
      data,
      ConflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> update(String table, Map<String, dynamic> data) async {
    final db = await this.database;
    await db.delete(table);
  }
}
