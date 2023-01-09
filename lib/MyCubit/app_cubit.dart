import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysql1/mysql1.dart';
import 'package:semesterial_project_admin/Models/trip.dart';
import 'package:semesterial_project_admin/MyCubit/myData.dart';
import '../Models/bus.dart';
import '../Models/driver.dart';
import '../Models/manager.dart';
import '../Models/user.dart';
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
      print("Owis connect :($error) \n $stackTrace");
    });
  }

  Future<void> disConnect() async {
    emit(DisConnecting(StateType.successState, "DisConnecting"));
    await myDB!.close().then((value) {
      emit(DisConnected(StateType.successState, "DisConnected"));
    }).catchError((error, stackTrace) {
      emit(DisConnected(StateType.errorState, error.toString()));
      print("Owis disConnect :($error) \n $stackTrace");
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
      print("Owis insertDriver :($error) \n $stackTrace");
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
      print("Owis getDrivers :($error) \n $stackTrace");
    });
  }

  Future<void> deleteDriver(Driver d) async {
    await myDB!.query('delete from driver where driver_id=?;', [d.driverId]).then((value) {
      MyData.driversList.remove(d.driverId);
      emit(DeletedData(StateType.successState, "Deleted Driver Data "));
    }).catchError((error, stackTrace) {
      emit(DeletedData(StateType.errorState, error.toString()));
      print("Owis deleteDriver :($error) \n $stackTrace");
    });
  }

  Future<void> updateDriver(Driver newDriver) async {
    await myDB!.query('update driver set driver_name = ?,driver_phone=? where driver_id=?;',
        [newDriver.driverName, newDriver.driverPhone, newDriver.driverId]).then((value) {
      MyData.driversList[newDriver.driverId!] = newDriver;
      emit(UpdatedData(StateType.successState, "Updated Driver Data"));
    }).catchError((error, stackTrace) {
      emit(UpdatedData(StateType.errorState, error.toString()));
      print("Owis updateDriver :($error) \n $stackTrace");
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
      print("Owis insertBus :($error) \n $stackTrace");
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
      print("Owis getBus :($error) \n $stackTrace");
    });
  }

  Future<void> deleteBus(Bus b) async {
    await myDB!.query('delete from bus where bus_id=?;', [b.busId]).then((value) {
      MyData.busList.remove(b.busId);
      emit(DeletedData(StateType.successState, "Deleted Bus Data "));
    }).catchError((error, stackTrace) {
      emit(DeletedData(StateType.errorState, error.toString()));
      print("Owis deleteBus :($error) \n $stackTrace");
    });
  }

  Future<void> updateBus(Bus newBus) async {
    await myDB!.query('update bus set bus_number = ?,bus_seats=?,bus_type=? where bus_id = ?;',
        [newBus.busNumber, newBus.busSeats, newBus.busType, newBus.busId]).then((value) {
      MyData.busList[newBus.busId!] = newBus;
      emit(UpdatedData(StateType.successState, "Updated Bus Data"));
    }).catchError((error, stackTrace) {
      emit(UpdatedData(StateType.errorState, error.toString()));
      print("Owis updateBus :($error) \n $stackTrace");
    });
  }

  Future<void> getUser() async {
    emit(SelectingData(StateType.successState, "Selecting Users Data,Please wait"));
    await myDB!.query('select user_id,user_name,user_phone,user_address from user').then((value) {
      MyData.userList.clear();
      for (var row in value) {
        User u = User.fromDB(row);
        MyData.userList[u.userId] = u;
      }
      emit(SelectedData(StateType.successState, "Selected Users Data"));
    }).catchError((error, stackTrace) {
      emit(SelectedData(StateType.errorState, error.toString()));
      print("Owis getUser :($error) \n $stackTrace");
    });
  }

  Future<void> deleteUser(User u) async {
    await myDB!.query('delete from user where user_id=?;', [u.userId]).then((value) {
      MyData.userList.remove(u.userId);
      emit(DeletedData(StateType.successState, "Deleted user Data "));
    }).catchError((error, stackTrace) {
      emit(DeletedData(StateType.errorState, error.toString()));
      print("Owis deleteUser :($error) \n $stackTrace");
    });
  }

  Future<void> getUserTrips(User u) async {
    await myDB!.query('''select * from trip where trip_id in (
        select reservatin_trip_id from reservation
        where resrervation_user_id = ? );''', [u.userId]).then((value) {
      MyData.tripList.clear();
      MyData.totalAmount = 0;
      for (var row in value) {
        Trip t = Trip.fromDB(row);
        MyData.tripList[t.tripId!] = t;
        MyData.totalAmount += t.price;
      }
      emit(SelectedData(StateType.successState, "Selected ${u.userName} trip Data"));
    }).catchError((error, stackTrace) {
      emit(SelectedData(StateType.errorState, error.toString()));
      print("Owis getUserTrips :($error) \n $stackTrace");
    });
  }

  Future<void> deleteUserRes(User u, Trip t) async {
    await myDB!.query(
        'delete from reservation where reservatin_trip_id=? and resrervation_user_id =?;',
        [t.tripId, u.userId]).then((value) {
      MyData.tripList.remove(t.tripId);
      MyData.totalAmount -= t.price;
      emit(DeletedData(StateType.successState, "Deleted ${u.userName} trip Data "));
    }).catchError((error, stackTrace) {
      emit(DeletedData(StateType.errorState, error.toString()));
      print("Owis deleteUserReservation :($error) \n $stackTrace");
    });
  }

  Future<void> getManager() async {
    emit(SelectingData(StateType.successState, "Selecting manager Data,Please wait"));
    await myDB!.query('select * from manager').then((value) {
      MyData.manager = Manager.fromDB(value.first);
      emit(SelectedData(StateType.successState, "Selected manager Data"));
    }).catchError((error, stackTrace) {
      emit(SelectedData(StateType.errorState, error.toString()));
      print("Owis getManager :($error) \n $stackTrace");
    });
  }

  Future<void> updateManager(Manager manager) async {
    emit(SelectingData(StateType.successState, "update manager Data,Please wait"));
    await myDB!.query('update manager set manager_name=? ,manager_phone=? where manager_id =?',
        [manager.name, manager.phone, manager.id]).then((value) {
      MyData.manager = manager;
      emit(UpdatedData(StateType.successState, "Updated manager Data"));
    }).catchError((error, stackTrace) {
      emit(UpdatedData(StateType.errorState, error.toString()));
      print("Owis getManager :($error) \n $stackTrace");
    });
  }
}
