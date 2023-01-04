import 'package:mysql1/mysql1.dart';

class Bus {
  int? busId;
  int busNumber;
  int busSeats;
  String busType;

  Bus({this.busId, required this.busNumber, required this.busSeats, required this.busType});

  static Bus fromDB(ResultRow row) {
    return Bus(busId: row[0], busNumber: row[1], busSeats: row[2], busType: row[3]);
  }
}
