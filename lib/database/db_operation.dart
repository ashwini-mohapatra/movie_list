import 'package:movie_list/database/db_connection.dart';
import 'package:sqflite/sqflite.dart';

class db_operations{

  DatabaseConnection _db=DatabaseConnection();
  late Database _database;

  Future<Database> get database async{
    if(_database == null) {
      _database=await _db.setDatabase();
    }
    return _database;
  }
  save(table,data) async{
    var conn=await database;
    return await conn.insert(table, data);
  }

  getall(table) async{
    var conn = await database;
    return await conn.query(table);
  }

  delete(table,mid) async{
    var conn=await database;
    return await conn.delete(table,where: 'mid=?',whereArgs: [mid]);
  }

  getById(table, mid) async{
    var conn=await database;
    return await conn.query(table, where: 'mid=?',whereArgs:[mid]);
  }

  getByUId(table, uid) async{
    var conn=await database;
    return await conn.query(table, where: 'uid=?',whereArgs: [uid]);
  }

  update(table,data) async{
    var conn=await database;
    return await conn.update(table, data,where: 'mid=?',whereArgs: [data['mid']]);
  }
}