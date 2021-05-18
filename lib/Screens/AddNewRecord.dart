import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:temperature_monitor_system/Screens/AddMemberScreen.dart';
import 'package:temperature_monitor_system/helpers/SQLHelper.dart';

class AddNewRecordScreen extends StatefulWidget {
  static String routeString = "/AddNewRecord";
  AddNewRecordScreen({Key key}) : super(key: key);

  @override
  _AddNewRecordScreenState createState() => _AddNewRecordScreenState();
}

class _AddNewRecordScreenState extends State<AddNewRecordScreen> {
  String name;
  // List nameOfMems;
  TextEditingController _tempController;
  TextEditingController _oxyController;
  TextEditingController _pulseController;
  Future<List<dynamic>> nameOfMems;

  DateTime date;
  SQLHelper db;

  @override
  void initState() {
    db = SQLHelper();
    _tempController = TextEditingController();
    _oxyController = TextEditingController();
    _pulseController = TextEditingController();
    nameOfMems = db.getListOfNames();
    date = DateTime.now();

    super.initState();
  }

  void onHitSave() async {
    var userKeys = await db.getNameUIDKeyValPair();
    db.insertRecord(
      date: date,
      oxy: double.parse(_oxyController.text),
      pulse: int.parse(_pulseController.text),
      temp: double.parse(_tempController.text),
      uid: userKeys[name].toString(),
    );
    print("Saved to Database");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check), onPressed: () => onHitSave()),
      appBar: AppBar(
        title: Text("Add New Record"),
        actions: [
          IconButton(
              icon: Icon(Icons.sync),
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelRow(icon: Icon(Icons.person), text: "Name"),
              FutureBuilder(
                  future: nameOfMems,
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snap.hasError) {
                      print(snap.error);
                      return Text("Error");
                    }
                    List data = List.castFrom<dynamic, String>(snap.data);
                    print(data);
                    return DropdownButton(
                      onTap: () {
                        // setState(() {});
                      },
                      value: name,
                      hint: Text("Please Select A Member"),
                      items: data.map((e) {
                            return DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            );
                          }).toList() +
                          [
                            DropdownMenuItem(
                                child: Text("Please Select A Member"),
                                onTap: () {
                                  print("Pushing");
                                  Navigator.of(context)
                                      .pushNamed(AddMemberScreen.routeString);
                                })
                          ],
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    );
                  }),
              SizedBox(
                height: 30,
              ),
              labelRow(
                  text: "Temperature",
                  icon: SvgPicture.asset(
                    "assets/icons/temp.svg",
                    fit: BoxFit.scaleDown,
                    width: 25,
                  )),
              TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                controller: _tempController,
                decoration: InputDecoration(
                    hintText: "Enter Temperature in F",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 30,
              ),
              labelRow(
                  text: "Oxygen Level",
                  icon: SvgPicture.asset(
                    "assets/icons/o2.svg",
                    fit: BoxFit.scaleDown,
                    width: 25,
                    height: 25,
                  )),
              TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                controller: _oxyController,
                decoration: InputDecoration(
                    hintText: "Enter Oxygen Level",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 30,
              ),
              labelRow(text: "Pulse", icon: Icon(Icons.favorite)),
              TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                controller: _pulseController,
                decoration: InputDecoration(
                    hintText: "Enter Pulse Rate (in bpm)",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 30,
              ),
              labelRow(text: "Date", icon: Icon(Icons.calendar_today_outlined)),
              SizedBox(
                height: 15,
              ),
              Text(
                SQLHelper.returnDateString(date),
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
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
                child: Text("Change Date"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget labelRow({String text, Widget icon}) {
  return Container(
    width: 200,
    height: 25,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon
      ],
    ),
  );
}
