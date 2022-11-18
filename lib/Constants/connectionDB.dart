import 'package:mysql1/mysql1.dart';

class ConnectionDB {
  static ConnectionSettings setting = ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      password: 'root',
      db: 'bus_app_db');
}
