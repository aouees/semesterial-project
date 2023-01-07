import 'package:mysql1/mysql1.dart';

class User {
  int userId;
  String userName, userAddress, userPhone;

  User(
      {required this.userId,
      required this.userName,
      required this.userPhone,
      required this.userAddress});

  static User fromDB(ResultRow row) {
    return User(userId: row[0], userName: row[1], userPhone: row[2], userAddress: row[3]);
  }
}
