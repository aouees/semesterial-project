import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysql1/mysql1.dart';
import '../../Models/trip.dart';
import '../DB/myData.dart';
import '../../Models/bus.dart';
import '../../Models/driver.dart';
import '../../Models/manager.dart';
import '../../Models/user.dart';
import 'db_states.dart';
import '../../Constants/connectionDB.dart';

class Database extends Cubit<DatabaseStates> {
  Database() : super(InitialState());

  static Database get(context) => BlocProvider.of(context);

  MySqlConnection? _myDB;

  Future<void> connect() async {
    emit(LoadingState());

    await MySqlConnection.connect(ConnectionDB.setting).then((value) {
      _myDB = value;
      emit(Connected());
    }).catchError((error, stackTrace) {
      emit(ErrorConnectingDataState('[connect] $error'));
      print("Owis connect :($error) \n $stackTrace");
    });
  }

  Future<void> disConnect() async {
    emit(LoadingState());
    await _myDB!.close().then((value) {
      emit(DisConnected());
    }).catchError((error, stackTrace) {
      emit(ErrorDisConnectingDataState('[disConnect] $error'));
      print("Owis disConnect :($error) \n $stackTrace");
    });
  }

  Future<void> insertDriver(Driver d) async {
    emit(LoadingState());

    await _myDB!.query('insert into driver (driver_name,driver_phone) values ( ?, ?);',
        [d.driverName, d.driverPhone]).then((value) {
      d.driverId = value.insertId!;
      MyData.driversList[d.driverId!] = d;
      emit(InsertedData("تم اضافة بيانات السائق الجديد"));
    }).catchError((error, stackTrace) {
      if (MyData.driversList.containsKey(d.driverId)) {
        MyData.driversList.remove(d.driverId);
      }
      emit(ErrorInsertingDataState('[insertDriver] $error'));
      print("Owis insertDriver :($error) \n $stackTrace");
    });
  }

  Future<void> getDrivers() async {
    emit(LoadingState());
    await _myDB!.query('select * from driver').then((value) {
      MyData.driversList.clear();
      for (var row in value) {
        Driver d = Driver.fromDB(row);
        MyData.driversList[d.driverId!] = d;
      }

      emit(SelectedData("تم جلب بيانات السائقين "));
    }).catchError((error, stackTrace) {
      emit(ErrorSelectingDataState('[getDrivers] $error'));
      print("Owis getDrivers :($error) \n $stackTrace");
    });
  }

  Future<void> deleteDriver(Driver d) async {
    emit(LoadingState());

    await _myDB!.query('delete from driver where driver_id=?;', [d.driverId]).then((value) {
      MyData.driversList.remove(d.driverId);
      emit(DeletedData("تم حذف بيانات السائق"));
    }).catchError((error, stackTrace) {
      emit(ErrorDeletingDataState('[deleteDriver] $error'));
      print("Owis deleteDriver :($error) \n $stackTrace");
    });
  }

  Future<void> updateDriver(Driver newDriver) async {
    emit(LoadingState());

    await _myDB!.query('update driver set driver_name = ?,driver_phone=? where driver_id=?;',
        [newDriver.driverName, newDriver.driverPhone, newDriver.driverId]).then((value) {
      MyData.driversList[newDriver.driverId!] = newDriver;
      emit(UpdatedData("تم تحديث بيانات السائق"));
    }).catchError((error, stackTrace) {
      emit(ErrorUpdatingDataState('[updateDriver] $error'));
      print("Owis updateDriver :($error) \n $stackTrace");
    });
  }

  Future<void> insertBus(Bus b) async {
    emit(LoadingState());

    await _myDB!.query('insert into bus (bus_number,bus_seats,bus_type) values ( ?, ?,?);',
        [b.busNumber, b.busSeats, b.busType]).then((value) {
      b.busId = value.insertId!;
      MyData.busList[b.busId!] = b;
      emit(InsertedData("تم اضافة بيانات الحافلة الجديدة"));
    }).catchError((error, stackTrace) {
      if (MyData.busList.containsKey(b.busId)) {
        MyData.busList.remove(b.busId);
      }
      emit(ErrorInsertingDataState('[insertBus] $error'));
      print("Owis insertBus :($error) \n $stackTrace");
    });
  }

  Future<void> getBus() async {
    emit(LoadingState());
    await _myDB!.query('select * from bus').then((value) {
      MyData.busList.clear();
      for (var row in value) {
        Bus b = Bus.fromDB(row);
        MyData.busList[b.busId!] = b;
      }
      emit(SelectedData("تم جلب بيانات الحافلات"));
    }).catchError((error, stackTrace) {
      emit(ErrorSelectingDataState('[getBus] $error'));
      print("Owis getBus :($error) \n $stackTrace");
    });
  }

  Future<void> deleteBus(Bus b) async {
    emit(LoadingState());
    await _myDB!.query('delete from bus where bus_id=?;', [b.busId]).then((value) {
      MyData.busList.remove(b.busId);
      emit(DeletedData("تم حذف بيانات الحافلة"));
    }).catchError((error, stackTrace) {
      emit(ErrorDeletingDataState('[deleteBus] $error'));
      print("Owis deleteBus :($error) \n $stackTrace");
    });
  }

  Future<void> updateBus(Bus newBus) async {
    emit(LoadingState());
    await _myDB!.query('update bus set bus_number = ?,bus_seats=?,bus_type=? where bus_id = ?;',
        [newBus.busNumber, newBus.busSeats, newBus.busType, newBus.busId]).then((value) {
      MyData.busList[newBus.busId!] = newBus;
      emit(UpdatedData("تم تحديث بيانات الحافلة"));
    }).catchError((error, stackTrace) {
      emit(ErrorUpdatingDataState('[updateBus] $error'));
      print("Owis updateBus :($error) \n $stackTrace");
    });
  }

  Future<void> getUser() async {
    emit(LoadingState());
    await _myDB!.query('select user_id,user_name,user_phone,user_address from user').then((value) {
      MyData.userList.clear();
      for (var row in value) {
        User u = User.fromDB(row);
        MyData.userList[u.userId] = u;
      }
      emit(SelectedData("تم جلب بيانات الزبائن"));
    }).catchError((error, stackTrace) {
      emit(ErrorSelectingDataState('[getUser] $error'));
      print("Owis getUser :($error) \n $stackTrace");
    });
  }

  Future<void> deleteUser(User u) async {
    emit(LoadingState());
    await _myDB!.query('delete from user where user_id=?;', [u.userId]).then((value) {
      MyData.userList.remove(u.userId);
      emit(DeletedData("تم حذف بيانات الزبون"));
    }).catchError((error, stackTrace) {
      emit(ErrorDeletingDataState('[deleteUser] $error'));
      print("Owis deleteUser :($error) \n $stackTrace");
    });
  }

  Future<void> getUserTrips(User u) async {
    emit(LoadingState());
    await _myDB!.query('''select * from trip where trip_id in (
        select reservatin_trip_id from reservation
        where resrervation_user_id = ? );''', [u.userId]).then((value) {
      MyData.tripList.clear();
      MyData.totalAmount = 0;
      for (var row in value) {
        Trip t = Trip.fromDB(row);
        MyData.tripList[t.tripId!] = t;
        MyData.totalAmount += t.price;
      }
      emit(SelectedData("تم جلب الرحلات التي قام بها المستخدم:${u.userName}"));
    }).catchError((error, stackTrace) {
      emit(ErrorSelectingDataState('[getUserTrips] $error'));
      print("Owis getUserTrips :($error) \n $stackTrace");
    });
  }

  Future<void> deleteUserRes(User u, Trip t) async {
    emit(LoadingState());
    await _myDB!.query(
        'delete from reservation where reservatin_trip_id=? and resrervation_user_id =?;',
        [t.tripId, u.userId]).then((value) {
      MyData.tripList.remove(t.tripId);
      MyData.totalAmount -= t.price;
      emit(DeletedData("تم حذف ${t.tripName} من الزبون ${u.userName}"));
    }).catchError((error, stackTrace) {
      emit(ErrorDeletingDataState('[deleteUserRes] $error'));
      print("Owis deleteUserReservation :($error) \n $stackTrace");
    });
  }

  Future<void> getManager() async {
    emit(LoadingState());
    await _myDB!.query('select * from manager').then((value) {
      MyData.manager = Manager.fromDB(value.first);
      emit(SelectedData("تم جلب بيانات المدير"));
    }).catchError((error, stackTrace) {
      emit(ErrorSelectingDataState('[getManager] $error'));
      print("Owis getManager :($error) \n $stackTrace");
    });
  }

  Future<void> updateManager(Manager manager) async {
    emit(LoadingState());
    await _myDB!.query('update manager set manager_name=? ,manager_phone=? where manager_id =?',
        [manager.name, manager.phone, manager.id]).then((value) {
      MyData.manager = manager;
      emit(UpdatedData("تم تحديث بيانات المدير"));
    }).catchError((error, stackTrace) {
      emit(ErrorUpdatingDataState('[updateManager] $error'));

      print("Owis getManager :($error) \n $stackTrace");
    });
  }
}
