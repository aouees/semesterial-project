import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysql1/mysql1.dart';
import 'package:semesterial_project_admin/MyCubit/myData.dart';
import '../Models/driver.dart';
import '../MyCubit/app_states.dart';
import '../Constants/connectionDB.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  MySqlConnection? conn;

  Future<void> connect() async {
    emit(Connecting(StateType.successState, "Connecting"));
    await MySqlConnection.connect(ConnectionDB.setting).then((value) {
      conn = value;
      emit(Connected(StateType.successState, "Connected"));
    }).catchError((error, stackTrace) {
      emit(Connected(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> disConnect() async {
    emit(DisConnecting(StateType.successState, "DisConnecting"));
    await conn!.close().then((value) {
      emit(DisConnected(StateType.successState, "DisConnected"));
    }).catchError((error, stackTrace) {
      emit(DisConnected(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> insertDriver(Driver d) async {
    await conn!.query('insert into driver (driver_name,driver_phone) values ( ?, ?);',
        [d.driverName, d.driverPhone]).then((value) {
      d.driverId = value.insertId!;
      MyData.driversList[d.driverId!] = d;
      emit(InsertedData(StateType.successState, "Insert Driver Data"));
    }).catchError((error, stackTrace) {
      MyData.driversList.remove(d.driverId);
      emit(InsertedData(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> getDrivers() async {
    emit(SelectingData(StateType.successState, "Selecting Data,Please wait"));
    await conn!.query('select * from driver').then((value) {
      MyData.driversList.clear();
      for (var row in value) {
        Driver d = Driver.fromDB(row);
        MyData.driversList[d.driverId!] = d;
      }
      emit(SelectedData(StateType.successState, "Selected Driver Data"));
    }).catchError((error, stackTrace) {
      emit(SelectedData(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> deleteDriver(Driver d) async {
    await conn!.query('delete from driver where driver_id=?;', [d.driverId]).then((value) {
      MyData.driversList.remove(d.driverId);
      emit(DeletedData(StateType.successState, "Deleted Driver Data "));
    }).catchError((error, stackTrace) {
      emit(DeletedData(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> updateDriver(Driver newDriver) async {
    await conn!.query('update driver set driver_name = ?,driver_phone=? where driver_id=?;',
        [newDriver.driverName, newDriver.driverPhone, newDriver.driverId]).then((value) {
      MyData.driversList[newDriver.driverId!] = newDriver;
      emit(UpdatedData(StateType.successState, "Updated Driver Data"));
    }).catchError((error, stackTrace) {
      emit(UpdatedData(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }
}
