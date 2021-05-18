// import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path_provider/path_provider.dart';
import 'package:temperature_monitor_system/models/RecordModel.dart';
// import 'package:provider/provider.dart';

class DBHelper {
  sql.Database tempDataBase;

  static String returnDateString(DateTime dateTime) {
    Map monthKey = {
      1: "Jan",
      2: "Feb",
      3: "Mar",
      4: "Apr",
      5: "May",
      6: "Jun",
      7: "Jul",
      8: "Aug",
      9: "Sep",
      10: "Oct",
      11: "Nov",
      12: "Dec"
    };
    return "${dateTime.day} ${monthKey[dateTime.month]} ${dateTime.year}";
  }

  Future<void> initDatabase() async {
    if (tempDataBase != null) {
      print("Database Already Initialized");
      return;
    }
    print("Initializing Database");
    var path = await getApplicationDocumentsDirectory();
    tempDataBase = await sql.openDatabase(path.path + "/Database.db",
        version: 3, onCreate: (db, version) {
      db.execute(
          "CREATE TABLE IF NOT EXISTS UserData(uid INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, gender TEXT,blood_group TEXT,contact TEXT)");
      db.execute(
          "CREATE TABLE IF NOT EXISTS TemperatureData(rec_id INTEGER PRIMARY KEY AUTOINCREMENT,uid TEXT, temp REAL, oxy REAL,pulse INTEGER,date TEXT,FOREIGN KEY(uid) REFERENCES UserData(uid))");
    });
    print("Database Initialized");
    tempDataBase.execute(
        "CREATE TABLE IF NOT EXISTS UserData(uid INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, gender TEXT,blood_group TEXT,contact TEXT)");
    tempDataBase.execute(
        "CREATE TABLE IF NOT EXISTS TemperatureData(rec_id INTEGER PRIMARY KEY AUTOINCREMENT,uid TEXT, temp REAL, oxy REAL,pulse INTEGER,date TEXT,FOREIGN KEY(uid) REFERENCES UserData(uid))");
    // var rawMap = await tempDataBase.rawQuery("SELECT * FROM UserData");
    // rawMap.forEach((element) {
    //   uidIndex.addAll({element['uid']: element['name']});
    // });
  }

  void updateRecord(
      {String rec_id,
      double temp,
      double oxy,
      DateTime date,
      int pulse}) async {
    await initDatabase();
    tempDataBase.update(
        "TemperatureData",
        {
          "temp": temp,
          "oxy": oxy,
          "pulse": pulse,
          "date": returnDateString(date),
        },
        where: 'rec_id=?',
        whereArgs: [rec_id]);
  }

  void deleteRecord(String rec_id) async {
    await initDatabase();
    tempDataBase
        .delete("TemperatureData", where: "rec_id=?", whereArgs: [rec_id]);
  }

  void insertRecord(
      {String uid, double temp, double oxy, DateTime date, int pulse}) async {
    await initDatabase();
    tempDataBase.insert("TemperatureData", {
      "uid": uid,
      "temp": temp,
      "oxy": oxy,
      "pulse": pulse,
      "date": returnDateString(date),
    });
  }

  void addUser(
      {String name,
      int age,
      String gender,
      String blood_group,
      String contact}) async {
    await initDatabase();
    tempDataBase.insert("UserData", {
      'name': name,
      'age': age,
      'gender': gender,
      'blood_group': blood_group,
      'contact': contact
    });
  }

  Future<List> getUsers() async {
    await initDatabase();
    return await tempDataBase.rawQuery("SELECT * FROM UserData");
  }

  void deleteUser(String uid) async {
    await initDatabase();
    tempDataBase.delete("UserData", where: "uid=?", whereArgs: [uid]);
    tempDataBase.delete("TemperatureData", where: "uid=?", whereArgs: [uid]);
  }

  void updateUser(
      {String uid,
      String name,
      int age,
      String gender,
      String blood_group,
      String contact}) async {
    await initDatabase();
    tempDataBase.update(
        "UserData",
        {
          'name': name,
          'age': age,
          'gender': gender,
          'blood_group': blood_group,
          'contact': contact
        },
        where: "uid=?",
        whereArgs: [uid]);
  }

  Future<List> getRecords(DateTime dtime) async {
    await initDatabase();
    print("Initiating GetRecords");
    var qRes = await tempDataBase.rawQuery(
        "SELECT * FROM TemperatureData WHERE Date='${returnDateString(dtime)}'");
    return qRes;
    // qRes.forEach((e) async {
    //   var uid = await getNameFromUID(e['uid']);
    //   print(e['uid']);
    //   print(uid);
    //   print(e['pulse']);
    //   out.add(uid);

    // out.add(Record(
    //     name: uid,
    //     uid: e['uid'],
    //     oxygen: e['oxy'],
    //     temperature: e['temp'],
    //     pulse: e['pulse'],
    //     date: e['date']));
    // });
    // print("GetRecords over");
    // return out;
  }

  Future<String> getNameFromUID(String uid) async {
    await initDatabase();
    List nameList = await tempDataBase
        .rawQuery("SELECT NAME from UserData WHERE uid='$uid'");
    return nameList[0]['name'];
  }

  Future<List> getListOfNames() async {
    print("Getting List Of names");
    List out = [];
    initDatabase().then((value) async {
      List namList = await tempDataBase.rawQuery("SELECT name from UserData");

      namList.forEach((element) {
        out.add(element['name'].toString());
      });
      print("From Future");
      print(out);
    });

    return out;
  }

  Future getNameUIDKeyValPair() async {
    await initDatabase();
    List namList = await tempDataBase.rawQuery("SELECT uid,name from UserData");
    Map out = {};
    namList.forEach((element) {
      out.addAll({element['name']: element['uid']});
    });
    return out;
  }

  void killDataBase() {
    tempDataBase.close();
  }
}
