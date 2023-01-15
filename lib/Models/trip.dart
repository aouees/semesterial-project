import 'package:mysql1/mysql1.dart';

class Trip {
  int? tripId;
  String tripName, tripType;
  String tripTime;
  String tripDate;
  String busDetails, driverDetails;
  double price;

  Trip(
      {this.tripId,
      required this.tripName,
      required this.tripType,
      required this.tripTime,
      required this.tripDate,
      required this.price,
      required this.busDetails,
      required this.driverDetails});

  static Trip fromDB(ResultRow row) {
    return Trip(
        tripId: row[0],
        tripName: row[1],
        tripType: row[2],
        tripTime: row[3],
        tripDate: row[4],
        price: row[5],
        busDetails: row[6],
        driverDetails: row[7]);
  }
}
