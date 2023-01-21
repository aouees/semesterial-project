import 'package:mysql1/mysql1.dart';

class Reservation {
  int id, userId, type;
  String username, address;

  Reservation(this.id, this.userId, this.username, this.address, this.type);

  static Reservation fromDB(ResultRow row) {
    return Reservation(row[0], row[1], row[2], row[3], row[4]);
  }
}
