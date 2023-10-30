import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// DBHelper is a Singleton class (only one instance)
class DBHelper {
  static const String _databaseName = 'decksDB.db';
  static const int _databaseVersion = 1;

  DBHelper._(); // private constructor (can't be called from outside)

  // the single instance
  static final DBHelper _singleton = DBHelper._();

  // factory constructor that always returns the single instance
  factory DBHelper() => _singleton;

  // the singleton will hold a reference to the database once opened
  Database? _database;

  // initialize the database when it's first requested
  get db async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    // use path_provider to get the platform-dependent documents directory
    var dbDir = await getApplicationDocumentsDirectory();

    // path.join joins two paths together, and is platform aware
    var dbPath = path.join(dbDir.path, _databaseName);

    print(dbPath);

    // open the database
    var db = await openDatabase(dbPath,
        version: _databaseVersion, // used for migrations

        // called when the database is first created
        onCreate: (Database db, int version) async {
      // create the customer table
      await db.execute('''
          CREATE TABLE decks(
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT
          )
        ''');
      // create the purchase_order table (can't use "order" as it's a keyword)
      await db.execute('''
          CREATE TABLE fcards(
            id INTEGER PRIMARY KEY,
            description TEXT,
            answer TEXT,
            decks_id INTEGER,
            add_time INTEGER,
            FOREIGN KEY (decks_id) REFERENCES decks(id)
          )
        ''');
    });

    return db;
  }

  // fetch records from a table with an optional "where" clause
  Future<List<Map<String, dynamic>>> query(String table,
      {String? where}) async {
    final db = await this.db;
    return where == null ? db.query(table) : db.query(table, where: where);
  }

  // insert a record into a table
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    final id = await db.insert(table, data);
    return id;
  }

  // update a record in a table
  Future<void> update(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  // delete a record from a table
  Future<void> delete(String table, int id) async {
    final db = await this.db;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
