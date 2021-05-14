import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:temperature_monitor_system/helpers/DBHelper.dart';
import 'AddNewRecord.dart';

class EditMemberScreen extends StatefulWidget {
  static String routeString = "/MemberScreen/EditMemberScreen";
  String name;
  String uid;
  int age;
  String gender;
  String bloodGroup;
  String contact;
  EditMemberScreen(
      {@required this.age,
      @required this.bloodGroup,
      @required this.contact,
      @required this.gender,
      @required this.name,
      @required this.uid});

  @override
  _EditMemberScreenState createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  DBHelper db;
  TextEditingController _nameController;
  TextEditingController _ageController;
  TextEditingController _bloodController;
  TextEditingController _phoneController;
  String gender;
  final snackBar = SnackBar(content: Text('Please Enter All Required Fields'));
  @override
  void initState() {
    gender = widget.gender == "M"
        ? "Male"
        : widget.gender == "F"
            ? "Female"
            : "Other";
    db = DBHelper();
    _nameController = TextEditingController(text: widget.name);
    _ageController = TextEditingController(text: widget.age.toString());
    _bloodController = TextEditingController(text: widget.bloodGroup);
    _phoneController = TextEditingController(text: widget.contact);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var name = _nameController.text;
          var age = _ageController.text;
          var blood = _bloodController.text;
          var cont = _phoneController.text;
          if (name.isEmpty ||
              age.isEmpty ||
              blood.isEmpty ||
              cont.isEmpty ||
              gender.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
          db.updateUser(
              age: int.parse(age),
              uid: widget.uid,
              name: name,
              blood_group: blood,
              contact: cont,
              gender: gender == "Male"
                  ? "M"
                  : gender == "Female"
                      ? "F"
                      : "Other");
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
      ),
      appBar: AppBar(
        title: Text("Edit Member"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                db.deleteUser(widget.uid);
                Navigator.of(context).pop();
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelRow(text: "Name", icon: Icon(Icons.person)),
              TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                controller: _nameController,
                decoration: InputDecoration(
                    hintText: "Enter Name",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 30,
              ),
              labelRow(text: "Age", icon: Container()),
              TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                controller: _ageController,
                decoration: InputDecoration(
                    hintText: "Enter Age",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 30,
              ),
              labelRow(text: "Gender", icon: Container()),
              DropdownButton(
                  value: gender,
                  onChanged: (v) {
                    setState(() {
                      gender = v;
                    });
                  },
                  items: ["Male", "Female", "Other"].map((el) {
                    return DropdownMenuItem(
                      child: Text(el),
                      value: el,
                    );
                  }).toList()),
              labelRow(
                  text: "Blood Group",
                  icon: SvgPicture.asset(
                    "assets/icons/drop.svg",
                    fit: BoxFit.scaleDown,
                    width: 25,
                    height: 25,
                    color: Colors.black,
                  )),
              TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                controller: _bloodController,
                decoration: InputDecoration(
                    hintText: "Enter Blood Group",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 30,
              ),
              labelRow(text: "Contact Number", icon: Icon(Icons.phone)),
              TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                controller: _phoneController,
                decoration: InputDecoration(
                    hintText: "Enter Contact Number",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
