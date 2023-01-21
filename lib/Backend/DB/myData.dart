import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:semesterial_project_admin/Models/manager.dart';

import '../../Models/driver.dart';
import '../../Models/reservation.dart';
import '../../Models/trip.dart';

import '../../Models/user.dart';

import '../../Models/bus.dart';

class MyData {
  static Map<int, Driver> driversList = {};
  static List<SelectedListItem> driverItems = [];
  static Map<int, Bus> busList = {};
  static List<SelectedListItem> busItems = [];
  static List<SelectedListItem> timeItems = [];
  static Map<int, User> userList = {};
  static Map<int, Trip> tripList = {};
  static Map<int, Trip> tripListOnPast = {};
  static double totalAmount = 0;
  static Manager? manager;
  static Map<int, Reservation> reservationList = {};
}
