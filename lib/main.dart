import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Backend/DB/database.dart';
import '../Screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<Database>(
        create: (context) => Database(),
        child: const MaterialApp(
          title: 'Bus Reservation Manager',
          home: HomeScreen(),
        ));
  }
}
