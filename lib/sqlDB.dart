import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDB {
   Database? db;

  initialDB() async {
    String dbpath = await getDatabasesPath();
    String path = join(dbpath, 'myDB.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
    CREATE TABLE notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    note TEXT
    )
    ''');
      print('----------------DATABASE CREATED----------------');
    }, onUpgrade: (Database d, int oldversion, int newversion) {
      print('--------------DATABASE UPDATED-------------------');
    });
    return db;
  }

  queryData(String sql) async {
    List respons = await db!.rawQuery(sql);
    return respons;
  }

  insertData(String sql) async {
    int respons = await db!.rawInsert(sql);
    return respons;
  }

  insert(String sql, Map<String, Object> st) async {
    int respons = await db!.insert(sql, st);
    return respons;
  }

  deleteData(String sql) async {
    int respons = await db!.rawDelete(sql);
    return respons;
  }

  delete(int id)async{
    int response = await db!.delete('notes',where: 'id = ? ',whereArgs: [id]);
    return response;
  }

  updateData(String sql) async {
    int respons = await db!.rawUpdate(sql);
    return respons;
  }

  update(int id , Map<String,Object> map)async{
    int response = await db!.update('notes', map,where: 'id = ?',whereArgs: [id],);
    return response;
  }

  deleteAll() async {
    String dbpath = await getDatabasesPath();
    String path = join(dbpath, 'myDB.db');
    await deleteDatabase(path);
    print('---------- DATABASE DELETED ------------');
  }
}
