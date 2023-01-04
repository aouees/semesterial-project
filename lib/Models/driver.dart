import 'package:mysql1/mysql1.dart';

class Driver {
  int? driverId;
  String driverName;
  String driverPhone;

  Driver({this.driverId, required this.driverName, required this.driverPhone});

  static Driver fromDB(ResultRow row) {
    return Driver(driverId: row[0], driverName: row[1], driverPhone: row[2]);
  }
}
