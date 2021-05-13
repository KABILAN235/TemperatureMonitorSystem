import 'package:flutter/material.dart';
import 'package:temperature_monitor_system/Screens/AddMemberScreen.dart';
import 'package:temperature_monitor_system/Screens/EditMemberScreen.dart';
import 'package:temperature_monitor_system/helpers/DBHelper.dart';

class MemberScreen extends StatefulWidget {
  static String routeString = "/MemberScreen";
  MemberScreen({Key key}) : super(key: key);

  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  DBHelper db;
  @override
  void initState() {
    db = DBHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(AddMemberScreen.routeString);
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Member Management"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          child: FutureBuilder(
              future: db.getUsers(),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snap.hasError) {
                  print(snap.error);
                  return Text("Error");
                }
                List userData = snap.data;
                print(userData);
                if (userData.length == 0) {
                  return Center(
                    child: Text(
                      "No Members Added",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  );
                }
                return DataTable(
                  showBottomBorder: true,
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(label: Text("Name"), numeric: false),
                    DataColumn(label: Text("Age"), numeric: true),
                    DataColumn(label: Text("Gender"), numeric: false),
                    DataColumn(label: Text("Blood Group"), numeric: false),
                    DataColumn(label: Text("Contact Number")),
                  ],
                  rows: userData.map((e) {
                    return DataRow(
                        onSelectChanged: (value) async {
                          await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return EditMemberScreen(
                                age: e['age'],
                                bloodGroup: e['blood_group'],
                                contact: e['contact'],
                                gender: e['gender'],
                                name: e['name'],
                                uid: e['uid'].toString());
                          }));
                          setState(() {});
                        },
                        cells: [
                          DataCell(Text(e['name'])),
                          DataCell(Text(e['age'].toString())),
                          DataCell(Text(e['gender'])),
                          DataCell(Text(e['blood_group'])),
                          DataCell(Text(e["contact"]))
                        ]);
                  }).toList(),
                  // rows: [
                  //   DataRow(cells: [
                  //     DataCell(Text("Kabilan")),
                  //     DataCell(Text("18")),
                  //     DataCell(Text("M")),
                  //     DataCell(Text("O+ve")),
                  //     DataCell(Text("7603850928"))
                  //   ])
                  // ],
                );
              }),
        ),
      ),
    );
  }
}
