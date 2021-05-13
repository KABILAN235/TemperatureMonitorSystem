import 'package:flutter/material.dart';

class Record {
  String name;
  String uid;
  double temperature, oxygen;
  int pulse;
  String date;
  Record({
    @required this.name,
    @required this.uid,
    @required this.oxygen,
    @required this.pulse,
    @required this.temperature,
    @required this.date,
  });

  void modifyTemp(double temp) {
    temperature = temp;
  }

  void modifyOxy(double oxy) {
    oxygen = oxy;
  }
}
