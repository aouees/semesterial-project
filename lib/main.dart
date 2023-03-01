import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'Backend/DB/database.dart';
import '../Screens/home_screen.dart';
import 'Components/error.dart';

void main() {
  onError();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<Database>(
        create: (context) => Database()..connect(),
        child: const MaterialApp(
          title: 'Bus Reservation Manager',
          home: HomeScreen(),
        ));
  }
}
