import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  late Database db;
  static const NEW_DB_VERSION = 1;

  initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "snapper_session.db");

    SharedPreferences _preferences = await SharedPreferences.getInstance();
    int? _firstInstall = _preferences.getInt("firstInstall");
    if (_firstInstall == null) {
      await deleteDatabase(path);
      _preferences.setInt("firstInstall", 1);
    }

    // Check if the database exists
    var exists = await databaseExists(path);
    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print("error ${e.toString()}");
      }

      // Copy from asset
      ByteData data = await rootBundle.load("assets/snapper_session.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
      //open the newly created db
      db = await openDatabase(path, version: NEW_DB_VERSION);
    } else {
      print("Database exist");
//      String _newColumn = "umur";
//      bool isExist = false;
//      var databasesPath = await getDatabasesPath();
//      var path = join(databasesPath, "research_sqlite_add_column.db");
//      db = await openDatabase(path);
//      int _dbVesrion = await db.getVersion();
//      print("check db version $_dbVesrion");
//      List _result = await db.rawQuery("PRAGMA table_info('t_user')");
//      for(var i=0; i < _result.length; i++){
//        if(_result[i]['name']== _newColumn){
//          isExist = true;
//        }
//      }
//
//      if(isExist){
//        return;
//      }
//      else{
//        await db.rawQuery("ALTER TABLE t_user ADD COLUMN umur VARCHAR(100)");
//      }
    }
  }

  Future<List> getAllData() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "snapper_session.db");
    db = await openDatabase(path);
    List _result = await db.rawQuery("select * from t_user_and_url");
    db.close();
    return _result;
  }

  deleteData() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "snapper_session.db");
    db = await openDatabase(path);
    await db.rawQuery("delete from t_user_and_url");
    db.close();
  }

  insertData(Map data) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "snapper_session.db");
    db = await openDatabase(path);
    await db.rawQuery(
        "insert into t_user_and_url(company_id,email,url,status,expired_date) "
        "values('${data['company_id']}','${data['email']}','${data['url']}','${data['status']}',"
        "'${data['expired_date']}')");
    db.close();
  }

  Future<List> checkEmail(int id) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "snapper_session.db");
    db = await openDatabase(path);
    List _result =
        await db.rawQuery("select email from t_user_and_url where id = $id");
    db.close();
    return _result;
  }

  Future<int> updateEmailLogout(int id) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "snapper_session.db");
    db = await openDatabase(path);
    var _result = await db
        .rawUpdate("update t_user_and_url set email = '' where id = $id");
//    var _result = await db.rawQuery("update t_user_and_url set email = '' where id = $id");
    db.close();
    return _result;
  }

  Future<int> updateEmailLogin(int id, String email) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "snapper_session.db");
    db = await openDatabase(path);
    var _result = await db
        .rawUpdate("update t_user_and_url set email = '$email' where id = $id");
//    var _result = await db.rawQuery("update t_user_and_url set email = '' where id = $id");
    db.close();
    return _result;
  }

  Future<int> updateExpiredDate(int id, String expiredDate) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "snapper_session.db");
    db = await openDatabase(path);
    var _result = await db.rawUpdate(
        "update t_user_and_url set expired_date = '$expiredDate' where id = $id");
//    var _result = await db.rawQuery("update t_user_and_url set email = '' where id = $id");
    db.close();
    return _result;
  }

  Future<int> updateUrl(int id, String url) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "snapper_session.db");
    db = await openDatabase(path);
    var _result = await db
        .rawUpdate("update t_user_and_url set url = '$url' where id = $id");
//    var _result = await db.rawQuery("update t_user_and_url set email = '' where id = $id");
    db.close();
    return _result;
  }

  Future<int> updateLoginMethod(int id, String method) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "snapper_session.db");
    db = await openDatabase(path);
    var _result = await db.rawUpdate(
        "update t_user_and_url set login_method = '$method' where id = $id");
    db.close();
    return _result;
  }
}
