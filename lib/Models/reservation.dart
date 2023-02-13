import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Reservation {
  int id, userId, type;
  String username, address;
  TextEditingController tripController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Reservation(this.id, this.userId, this.username, this.address, this.type);

  static Reservation fromDB(ResultRow row) {
    return Reservation(row[0], row[1], row[2], row[3], row[4]);
  }
}
