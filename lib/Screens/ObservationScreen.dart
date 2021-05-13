import 'package:flutter/material.dart';
import 'package:temperature_monitor_system/Screens/EditAndViewRecord.dart';
import 'package:temperature_monitor_system/helpers/DBHelper.dart';
import 'AddNewRecord.dart';

class ObservationTableScreen extends StatefulWidget {
  static String routeString = "/Observation";
  const ObservationTableScreen({
    Key key,
  }) : super(key: key);

  @override
  _ObservationTableScreenState createState() => _ObservationTableScreenState();
}

class _ObservationTableScreenState extends State<ObservationTableScreen> {
  DBHelper db;
  Future tableData;
  DateTime date;
  @override
  void initState() {
    db = DBHelper();
    date = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).pushNamed(AddNewRecordScreen.routeString);
          setState(() {});
        },
      ),
      appBar: AppBar(
        title: Text("Log Inspector"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => showDatePicker(
                    context: context,
                    firstDate: DateTime.parse("2010-01-01"),
                    initialDate: date,
                    lastDate: DateTime.parse("2100-01-01"),
                  ).then((value) {
                    setState(() {
                      date = value;
                    });
                  }),
                  child: Text(
                    "Change Date",
                  ),
                ),
                Spacer(),
                Text(DBHelper.returnDateString(date),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 15,
                ),
                Icon(Icons.calendar_today_outlined)
              ],
            ),
            StreamBuilder(
                stream: db.getRecords(date).asStream(),
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  List data = snap.data;
                  if (data.length == 0) {
                    return Center(
                      child: Text(
                        "No Logs On ${DBHelper.returnDateString(date)}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        showBottomBorder: true,
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(
                            label: Text(
                              "Name",
                            ),
                            tooltip: "Name",
                            numeric: false,
                          ),
                          DataColumn(
                            label: Text("Temperature"),
                            tooltip: "Temperature",
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text("Oxygen Level"),
                            tooltip: "Oxygen Level",
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text("Pulse"),
                            tooltip: "Pulse",
                            numeric: true,
                          )
                        ],
                        rows: data.map((e) {
                          return DataRow(
                            onSelectChanged: (v) async {
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (ctx) {
                                return UpdateRecordScreen(
                                    uid: e['uid'],
                                    rec_id: e['rec_id'],
                                    date: date,
                                    oxy: e['oxy'],
                                    pulse: e['pulse'],
                                    temp: e['temp']);
                              }));
                              setState(() {});
                            },
                            cells: [
                              DataCell(StreamBuilder(
                                  stream:
                                      db.getNameFromUID(e['uid']).asStream(),
                                  builder: (ctx, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text(e['uid']);
                                    }
                                    String textC = snap.data;
                                    return Text(textC);
                                  })),
                              DataCell(Text(e['temp'].toString())),
                              DataCell(Text(e['oxy'].toString())),
                              DataCell(Text(e['pulse'].toString())),
                            ],
                          );
                        }).toList(),
                        // rows: [
                        //   DataRow(
                        //     cells: [
                        //       DataCell(Text("Kabilan")),
                        //       DataCell(Text("100")),
                        //       DataCell(Text("100")),
                        //       DataCell(Text("99"))
                        //     ],
                        //   )
                        // ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
