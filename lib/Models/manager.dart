import 'package:mysql1/mysql1.dart';

class Manager {
  int id;
  String name, phone;

  Manager({required this.id, required this.name, required this.phone});

  static Manager fromDB(ResultRow row) {
    return Manager(id: row[0], name: row[1], phone: row[2]);
  }
}
