import 'package:semesterial_project_admin/MyCubit/app_cubit.dart';

abstract class AppStates {
  @override
  String toString() {
    return stateName;
  }

  String get stateName;
}

class InitialState extends AppStates {
  @override
  String get stateName => 'InitialState';
}

class SuccessState extends AppStates {
  String msg;

  SuccessState(this.msg);

  @override
  String get stateName => "Success : $msg";
}

class ErrorState extends AppStates {
  late String msg;

  ErrorState(this.msg);

  @override
  String get stateName => "Error : $msg";
}


