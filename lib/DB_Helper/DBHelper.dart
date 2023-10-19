import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? database;

  Future<bool> getDBDirectory() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "record.db");

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            "CREATE TABLE tblRecord (id INTEGER PRIMARY KEY AUTOINCREMENT,fname TEXT,mname TEXT,lname TEXT,email TEXT,countryCode TEXT,phone TEXT,lbl1 TEXT,lbl2 TEXT,address TEXT,company TEXT,sip TEXT,notes TEXT,gender TEXT,hobby TEXT,image TEXT)");
      },
    );

    return true;
  }
}
