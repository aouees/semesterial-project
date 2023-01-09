import 'package:mysql1/mysql1.dart';

class Trip {
  int? tripId;
  String tripName, tripType, tripTime, tripDate;
  int busID, driverID;
  double price;

  Trip(
      {this.tripId,
      required this.tripName,
      required this.tripType,
      required this.tripTime,
      required this.tripDate,
      required this.price,
      required this.busID,
      required this.driverID});

  static Trip fromDB(ResultRow row) {
    return Trip(
        tripId: row[0],
        tripName: row[1],
        tripType: row[2],
        tripTime: row[3].toString().substring(0, 8),
        tripDate: row[4].toString().substring(0, 10),
        price: row[5],
        busID: row[6],
        driverID: row[7]);
  }
}
