import 'package:mysql1/mysql1.dart';

class SQLHelper {
  SQLHelper() {
    initDatabase();
  }
  MySqlConnection connection;
  static ConnectionSettings settings = ConnectionSettings(
    user: "root",
    password: "12345678",
    host: "localhost",
    db: "tempmonitor",
    port: 3306,
  );

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
    if (connection != null) {
      print("Database Already Initialized");
      return;
    }
    connection = await MySqlConnection.connect(settings);
    await connection.query(
        "CREATE TABLE IF NOT EXISTS UserData(uid INT(4) PRIMARY KEY AUTO_INCREMENT, name VARCHAR(20), age INT(2), gender CHAR(1),blood_group VARCHAR(6),contact CHAR(10));");
    await connection.query(
        "CREATE TABLE IF NOT EXISTS TemperatureData(rec_id INT(4) PRIMARY KEY AUTO_INCREMENT,uid INT(4), temp FLOAT(3), oxy FLOAT(3),pulse INT(3),date VARCHAR(17),FOREIGN KEY(uid) REFERENCES UserData(uid));");
    print("Database Initialized");
  }

  //User Utilities

  Future<void> addUser(
      {String name,
      int age,
      String gender,
      String blood_group,
      String contact}) async {
    await initDatabase();
    connection.query(
        "INSERT INTO userdata(name,age,gender,blood_group,contact) VALUES('$name',$age,'$gender','$blood_group','$contact');");
  }

  Future<List> getUsers() async {
    await initDatabase();
    var res = await connection.query("SELECT * FROM UserData");
    return res.map((e) {
      return e.fields;
    }).toList();
  }

  void deleteUser(String uid) async {
    await initDatabase();
    connection.query("DELETE FROM userdata WHERE uid=$uid;");
    connection.query("DELETE FROM TemperatureData WHERE uid=$uid;");
  }

  void updateUser(
      {String uid,
      String name,
      int age,
      String gender,
      String blood_group,
      String contact}) async {
    await initDatabase();
    connection.query(
        " UPDATE userdata SET Name='$name', age=$age,gender='$gender', blood_group='$blood_group',contact='$contact' WHERE uid=$uid;");
  }

  Future<String> getNameFromUID(String uid) async {
    await initDatabase();
    Results nameList =
        await connection.query("SELECT NAME from UserData WHERE uid='$uid';");
    return nameList.toList()[0].fields['NAME'];
  }

  Future<List> getListOfNames() async {
    print("Getting List Of names");
    List out = [];
    await initDatabase().then((value) async {
      Results namList = await connection.query("SELECT name from UserData;");
      namList.toList().forEach((element) {
        out.add(element.fields['name']);
      });
    });

    return out;
  }

  Future getNameUIDKeyValPair() async {
    await initDatabase();
    Results namList = await connection.query("SELECT uid,name from UserData");
    Map out = {};
    namList.toList().forEach((element) {
      out.addAll({element.fields['name']: element.fields['uid']});
    });
    return out;
  }

  //Records Utilities

  Future<List> getRecords(DateTime dtime) async {
    await initDatabase();
    print("Initiating GetRecords");
    var qRes = await connection.query(
        "SELECT * FROM TemperatureData WHERE Date='${returnDateString(dtime)}'");
    print(qRes.toList().map((e) {
      return e.fields;
    }).toList());
    return qRes.toList().map((e) {
      return e.fields;
    }).toList();
  }

  void insertRecord(
      {String uid, double temp, double oxy, DateTime date, int pulse}) async {
    await initDatabase();

    connection.query(
        "INSERT INTO temperaturedata(uid,temp,oxy,pulse,date) values($uid,$temp,$oxy,$pulse,'${returnDateString(date)}');");
  }

  void deleteRecord(String rec_id) async {
    await initDatabase();
    connection.query("DELETE from temperaturedata where rec_id=$rec_id;");
  }

  void updateRecord(
      {String rec_id,
      double temp,
      double oxy,
      DateTime date,
      int pulse}) async {
    await initDatabase();
    connection.query(
        "UPDATE temperaturedata SET temp=$temp,oxy=$oxy,pulse=$pulse,date='${returnDateString(date)}' WHERE rec_id=$rec_id");
  }

  void killDataBase() {
    connection.close();
  }
}
