import 'package:flutter/material.dart';
import 'package:semesterial_project_admin/Screens/home_screen.dart';
// TODO: do state management for all screen &&
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bus Reservation Manager',
      home: HomeScreen(),
    );
  }
}
