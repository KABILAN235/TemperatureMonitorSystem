import 'package:flutter/material.dart';
import 'package:temperature_monitor_system/Screens/AddMemberScreen.dart';
import 'package:temperature_monitor_system/Screens/AddNewRecord.dart';
import 'package:temperature_monitor_system/Screens/MemberScreen.dart';
import 'package:temperature_monitor_system/Screens/ObservationScreen.dart';
import 'package:temperature_monitor_system/helpers/SQLHelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Temperature Monitor',
        theme: ThemeData(primarySwatch: Colors.purple),
        routes: {
          AddNewRecordScreen.routeString: (_) => AddNewRecordScreen(),
          AddMemberScreen.routeString: (_) => AddMemberScreen(),
          ObservationTableScreen.routeString: (_) => ObservationTableScreen(),
          MemberScreen.routeString: (_) => MemberScreen()
        },
        home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SQLHelper db;
  @override
  void initState() {
    db = SQLHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Temperature Monitor"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed(AddNewRecordScreen.routeString),
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        height: 1600,
        width: 1600,
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
              childAspectRatio: 1.4),
          children: [
            gridBox(
                color: Colors.red,
                text: "Log Inspector",
                onclik: () {
                  Navigator.of(context)
                      .pushNamed(ObservationTableScreen.routeString);
                },
                icon: Icon(
                  Icons.notes,
                  color: Colors.white,
                  size: 60,
                )),
            gridBox(
                color: Colors.blue,
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 60,
                ),
                onclik: () {
                  Navigator.of(context).pushNamed(MemberScreen.routeString);
                },
                text: "Member Management"),
            gridBox(
                color: Colors.green,
                onclik: () {
                  Navigator.of(context)
                      .pushNamed(AddNewRecordScreen.routeString);
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 60,
                ),
                text: "Add New Logs")
          ],
        ),
      ),
    );
  }

  Widget gridBox({String text, Widget icon, Color color, Function onclik}) {
    return GestureDetector(
      onTap: onclik,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: gridBoxDecors(color),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            icon
          ],
        ),
      ),
    );
  }

  BoxDecoration gridBoxDecors(Color color) {
    return BoxDecoration(boxShadow: [
      BoxShadow(
          offset: Offset(5, 5),
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10)
    ], color: color, borderRadius: BorderRadius.circular(20));
  }
}
