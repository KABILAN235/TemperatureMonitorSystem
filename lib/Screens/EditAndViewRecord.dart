import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:temperature_monitor_system/helpers/DBHelper.dart';

import 'AddMemberScreen.dart';
import 'AddNewRecord.dart';

class UpdateRecordScreen extends StatefulWidget {
  int rec_id;
  DateTime date;
  double oxy, temp;
  int pulse;
  String uid;
  static String routeString = "/Observation/Update";

  UpdateRecordScreen(
      {@required this.rec_id,
      @required this.uid,
      @required this.date,
      @required this.oxy,
      @required this.pulse,
      @required this.temp});

  @override
  _UpdateRecordScreenState createState() => _UpdateRecordScreenState();
}

class _UpdateRecordScreenState extends State<UpdateRecordScreen> {
  TextEditingController _tempController;
  TextEditingController _oxyController;
  TextEditingController _pulseController;
  DateTime date;
  DBHelper db;

  @override
  void initState() {
    db = DBHelper();
    _tempController = TextEditingController(text: widget.temp.toString());
    _oxyController = TextEditingController(text: widget.oxy.toString());
    _pulseController = TextEditingController(text: widget.pulse.toString());
    date = widget.date;
    super.initState();
  }

  void onHitSave() async {
    db.updateRecord(
        date: date,
        oxy: double.parse(_oxyController.text),
        pulse: int.parse(_pulseController.text),
        temp: double.parse(_tempController.text),
        rec_id: widget.rec_id.toString());
    print("Saved to Database");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check), onPressed: () => onHitSave()),
      appBar: AppBar(
        title: Text("Update Record"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                db.deleteRecord(widget.rec_id.toString());
                Navigator.of(context).pop();
              })
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelRow(icon: Icon(Icons.person), text: "Name"),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
                stream: db.getNameFromUID(widget.uid.toString()).asStream(),
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  String nm = snap.data;
                  return Text(
                    nm,
                    style: TextStyle(fontSize: 20),
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
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: true),
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
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: true),
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
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: true),
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
              DBHelper.returnDateString(date),
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
    );
  }
}
