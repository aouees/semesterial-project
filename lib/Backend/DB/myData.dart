import 'package:semesterial_project_admin/Models/manager.dart';

import '../../Models/driver.dart';
import '../../Models/trip.dart';

import '../../Models/user.dart';

import '../../Models/bus.dart';

class MyData {
  static Map<int, Driver> driversList = {};
  static Map<int, Bus> busList = {};
  static Map<int, User> userList = {};
  static Map<int, Trip> tripList = {};
  static double totalAmount = 0;
  static Manager? manager;
}
