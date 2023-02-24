import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDB {
  Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  initialDB() async {
    String _dbpath = await getDatabasesPath();
    String path = join(_dbpath, 'myDB._db');
    _db = await openDatabase(path, version: 1,
        onCreate: (Database _db, int version) async {
      await _db.execute('''
    CREATE TABLE notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    note TEXT
    )
    ''');
      print('----------------DATABASE CREATED----------------');
    }, onUpgrade: (Database d, int oldversion, int newversion) {
      print('--------------DATABASE UPDATED-------------------');
    });
    return _db;
  }

  queryData(String sql) async {
    List response = await _db!.rawQuery(sql);
    return response;
  }

  query() async {
    List response = await _db!.query('notes');
    return response;
  }

  insertData(String sql) async {
    int response = await _db!.rawInsert(sql);
    return response;
  }

  insert( Map<String, Object> st) async {
    int response = await _db!.insert('notes', st);
    return response;
  }

  deleteData(String sql) async {
    int response = await _db!.rawDelete(sql);
    return response;
  }

  delete(int id) async {
    int response =
        await _db!.delete('notes', where: 'id = ? ', whereArgs: [id]);
    return response;
  }

  updateData(String sql) async {
    int response = await _db!.rawUpdate(sql);
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

  deleteAll() async {
    String _dbpath = await getDatabasesPath();
    String path = join(_dbpath, 'myDB._db');
    await deleteDatabase(path);
    print('---------- DATABASE DELETED ------------');
  }
}
