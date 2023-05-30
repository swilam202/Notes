import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDB {
  static Database? _db;

  Future<Database> get db async {
    if (_db == null)
      return _db = await initDatabase();
    else
      return _db!;
  }

  initDatabase() async {
    String dbpath = await getDatabasesPath();
    String path = join(dbpath, 'cafe.db');

    Database myDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return myDb;
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
    CREATE TABLE notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    note TEXT NOT NULL,
    color INTEGER NOT NULL
    )
    ''');

    await batch.commit();
  }

  query() async {
    List response = await _db!.query('notes');
    return response;
  }

  insert(Map<String, Object> map) async {
    int response = await _db!.insert('notes', map);
    return response;
  }

  delete(int id) async {
    int response =
        await _db!.delete('notes', where: 'id = ? ', whereArgs: [id]);
    return response;
  }

  deleteAll() async {
    int response = await _db!.delete('notes');
    return response;
  }

  update(int id, Map<String, Object> map) async {
    int response = await _db!.update(
      'notes',
      map,
      where: 'id = ?',
      whereArgs: [id],
    );
    return response;
  }
}
