import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysql1/mysql1.dart';
import 'package:semesterial_project_admin/MyCubit/myData.dart';
import '../Models/bus.dart';
import '../Models/driver.dart';
import '../MyCubit/app_states.dart';
import '../Constants/connectionDB.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  MySqlConnection? myDB;

  Future<void> connect() async {
    emit(Connecting(StateType.successState, "Connecting"));

    await MySqlConnection.connect(ConnectionDB.setting).then((value) {
      myDB = value;
      emit(Connected(StateType.successState, "Connected"));
    }).catchError((error, stackTrace) {
      emit(Connected(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> disConnect() async {
    emit(DisConnecting(StateType.successState, "DisConnecting"));
    await myDB!.close().then((value) {
      emit(DisConnected(StateType.successState, "DisConnected"));
    }).catchError((error, stackTrace) {
      emit(DisConnected(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> insertDriver(Driver d) async {
    await myDB!.query('insert into driver (driver_name,driver_phone) values ( ?, ?);',
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
    emit(SelectingData(StateType.successState, "Selecting Drivers Data,Please wait"));
    await myDB!.query('select * from driver').then((value) {
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
    await myDB!.query('delete from driver where driver_id=?;', [d.driverId]).then((value) {
      MyData.driversList.remove(d.driverId);
      emit(DeletedData(StateType.successState, "Deleted Driver Data "));
    }).catchError((error, stackTrace) {
      emit(DeletedData(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> updateDriver(Driver newDriver) async {
    await myDB!.query('update driver set driver_name = ?,driver_phone=? where driver_id=?;',
        [newDriver.driverName, newDriver.driverPhone, newDriver.driverId]).then((value) {
      MyData.driversList[newDriver.driverId!] = newDriver;
      emit(UpdatedData(StateType.successState, "Updated Driver Data"));
    }).catchError((error, stackTrace) {
      emit(UpdatedData(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> insertBus(Bus b) async {
    await myDB!.query('insert into bus (bus_number,bus_seats,bus_type) values ( ?, ?,?);',
        [b.busNumber, b.busSeats, b.busType]).then((value) {
      b.busId = value.insertId!;
      MyData.busList[b.busId!] = b;
      emit(InsertedData(StateType.successState, "Insert Driver Data"));
    }).catchError((error, stackTrace) {
      if (MyData.busList.containsKey(b.busId)) {
        MyData.busList.remove(b.busId);
      }
      emit(InsertedData(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> getBus() async {
    emit(SelectingData(StateType.successState, "Selecting Buses Data,Please wait"));
    await myDB!.query('select * from bus').then((value) {
      MyData.busList.clear();
      for (var row in value) {
        Bus b = Bus.fromDB(row);
        MyData.busList[b.busId!] = b;
      }
      emit(SelectedData(StateType.successState, "Selected Bus Data"));
    }).catchError((error, stackTrace) {
      emit(SelectedData(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> deleteBus(Bus b) async {
    await myDB!.query('delete from bus where bus_id=?;', [b.busId]).then((value) {
      MyData.busList.remove(b.busId);
      emit(DeletedData(StateType.successState, "Deleted Bus Data "));
    }).catchError((error, stackTrace) {
      emit(DeletedData(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }

  Future<void> updateBus(Bus newBus) async {
    await myDB!.query('update bus set bus_number = ?,bus_seats=?,bus_type=? where bus_id = ?;',
        [newBus.busNumber, newBus.busSeats, newBus.busType, newBus.busId]).then((value) {
      MyData.busList[newBus.busId!] = newBus;
      emit(UpdatedData(StateType.successState, "Updated Bus Data"));
    }).catchError((error, stackTrace) {
      emit(UpdatedData(StateType.errorState, error.toString()));
      print("Owis : $stackTrace");
    });
  }
}
