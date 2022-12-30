import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semesterial_project_admin/MyCubit/app_cubit.dart';
import 'package:semesterial_project_admin/Screens/home_screen.dart';
import 'package:semesterial_project_admin/Screens/wait_screen.dart';
import 'MyCubit/app_states.dart';

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
      child: MaterialApp(
        title: 'Bus Reservation Manager',
        home: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state.type == StateType.errorState) {
              AppCubit.get(context).connect();
            }
          },
          builder: (context, state) {
            if (state is InitialState) {
              AppCubit.get(context).connect();
            }

            if (state is Connecting) {
              return const WaitScreen();
            }
            return HomeScreen();
          },
        ),
      ),
    );
  }
}
