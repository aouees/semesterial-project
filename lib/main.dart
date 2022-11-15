import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semesterial_project_admin/MyCubit/app_cubit.dart';
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
    return BlocProvider<AppCubit>(
      create: (context) => AppCubit(),
      child: const MaterialApp(
        title: 'Bus Reservation Manager',
        home: HomeScreen(),
      ),
    );
  }
}
