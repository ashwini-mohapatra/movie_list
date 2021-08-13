import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseConnection{

  setDatabase() async{
    var directory=await getApplicationDocumentsDirectory();
    var path = join(directory.path,'db_movielist');
    var db = openDatabase(path,version: 1,onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db,int version) async{
    await db.execute("CREATE TABLE movielist(mid INTEGER PRIMARY KEY, uid TEXT, name TEXT, director TEXT, image TEXT)");
  }
}