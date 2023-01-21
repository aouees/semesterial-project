import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysql1/mysql1.dart';
import 'package:semesterial_project_admin/Models/reservation.dart';
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
    MyData.driversList.clear();
    MyData.driverItems.clear();
    await _myDB!.query('select * from driver').then((value) {
      for (var row in value) {
        Driver d = Driver.fromDB(row);
        MyData.driversList[d.driverId!] = d;
        MyData.driverItems.add(SelectedListItem(name: d.driverName, value: d.driverId.toString()));
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
    MyData.busList.clear();
    MyData.busItems.clear();
    await _myDB!.query('select * from bus').then((value) {
      for (var row in value) {
        Bus b = Bus.fromDB(row);
        MyData.busList[b.busId!] = b;
        MyData.busItems.add(
            SelectedListItem(name: '${b.busType} - ${b.busNumber}', value: b.busId.toString()));
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
    await _myDB!.query('''
      select trip_id,trip_name,trip_type,trip_date,trip_price,
      concat( bus_type ,concat(' - ', bus_number)),
      driver_name from trip,bus,driver where
      driver_id=trip_driver_id 
      and bus_id=trip_bus_id and trip_id in (
      select reservatin_trip_id from reservation
      where resrervation_user_id = ? );
      ''', [u.userId]).then((value) {
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

  Future<void> getTrips() async {
    emit(LoadingState());
    MyData.tripList.clear();
    MyData.tripListOnPast.clear();
    await _myDB!.query('''
      select trip_id,trip_name,trip_type,trip_date,trip_price,
      concat( bus_type ,concat('-', bus_number)),
      driver_name from trip,bus,driver where
      driver_id=trip_driver_id 
      and bus_id=trip_bus_id;
       ''').then((value) {
      for (var row in value) {
        Trip trip = Trip.fromDB(row);
        var d = trip.tripDate;
        var now = DateTime.now();
        // past
        if (now.compareTo(d) == 1) {
          MyData.tripListOnPast[trip.tripId!] = trip;
        }
        // future and at same date
        else {
          MyData.tripList[trip.tripId!] = trip;
        }
      }
      emit(SelectedData('تم جلب بيانات الرحلات'));
    }).catchError((error, stackTrace) {
      emit(ErrorSelectingDataState('[getTrips] $error'));
      print("Owis getTrips :($error) \n $stackTrace");
    });
  }

  Future<Trip> getTripById(int id) async {
    emit(LoadingState());
    Trip t = await _myDB!.query('''
    select trip_id,trip_name,trip_type,
		trip_date,trip_price,
       concat(bus_id,concat('_' ,concat( bus_type ,concat(' - ', bus_number)))),
       concat(driver_id,concat('_', driver_name)) from trip,bus,driver,trip_time where
       driver_id=trip_driver_id 
       and bus_id=trip_bus_id
       and trip_id=?
       ;
    ''', [id]).then((value) {
      emit(SelectedData("تم جلب بيانات الرحلة"));
      return Trip.fromDB(value.first);
    }).catchError((error, stackTrace) {
      emit(ErrorSelectingDataState('[getTripById] $error'));
      print("Owis getTripById :($error) \n $stackTrace");
    });
    return t;
  }

  Future<void> insertTrip(Trip trip) async {
    emit(LoadingState());
    await _myDB!.query('''
    INSERT INTO trip
    (trip_name,
    trip_type,
    trip_date,
    trip_price,
    trip_driver_id,
    trip_bus_id)
    VALUES(?,?,?,?,?,?);
    ''', [
      trip.tripName,
      trip.tripType.split('_')[0],
      trip.tripDate.toUtc(),
      trip.price,
      int.parse(trip.driverDetails.split('_')[0]),
      int.parse(trip.busDetails.split('_')[0])
    ]).then((value) {
      trip.tripType = trip.tripType.split('_')[0];
      trip.busDetails = trip.busDetails.split('_')[1];
      trip.driverDetails = trip.driverDetails.split('_')[1];
      trip.tripId = value.insertId!;
      MyData.tripList[trip.tripId!] = trip;
      emit(InsertedData("تم اضافة بيانات الرحلة جديدة"));
    }).catchError((error, stackTrace) {
      if (MyData.tripList.containsKey(trip.tripId)) {
        MyData.tripList.remove(trip.tripId);
      }
      emit(ErrorInsertingDataState('[insertTrip] $error'));
      print("Owis insertTrip :($error) \n $stackTrace");
    });
  }

  Future<void> updateTrip(Trip trip) async {
    emit(LoadingState());
    await _myDB!.query('''
    update trip set 
    trip_name=?,
    trip_type=?,
    trip_date=?,
    trip_price=?,
    trip_driver_id=?,
    trip_bus_id=?
     where trip_id =?''', [
      trip.tripName,
      trip.tripType.split('_')[0],
      trip.tripDate.toUtc(),
      trip.price,
      int.parse(trip.driverDetails.split('_')[0]),
      int.parse(trip.busDetails.split('_')[0]),
      trip.tripId
    ]).then((value) {
      trip.tripType = trip.tripType.split('_')[0];
      trip.busDetails = trip.busDetails.split('_')[1];
      trip.driverDetails = trip.driverDetails.split('_')[1];
      MyData.tripList[trip.tripId!] = trip;
      emit(UpdatedData("تم تحديث بيانات الرحلة"));
    }).catchError((error, stackTrace) {
      emit(ErrorUpdatingDataState('[updateTrip] $error'));

      print("Owis updateTrip :($error) \n $stackTrace");
    });
  }

  Future<void> deleteTrip(Trip t) async {
    emit(LoadingState());
    await _myDB!.query('delete from trip where trip_id=? ;', [t.tripId]).then((value) {
      if (MyData.tripList.containsKey(t.tripId)) {
        MyData.tripList.remove(t.tripId);
      } else {
        MyData.tripListOnPast.remove(t.tripId);
      }
      emit(DeletedData("تم حذف بيانات الرحلة"));
    }).catchError((error, stackTrace) {
      emit(ErrorDeletingDataState('[deleteTrip] $error'));
      print("Owis deleteTrip :($error) \n $stackTrace");
    });
  }

  Future<void> getTime() async {
    emit(LoadingState());
    MyData.timeItems.clear();
    await _myDB!.query('select * from trip_time').then((value) {
      for (var row in value) {
        MyData.timeItems.add(SelectedListItem(name: row[1], value: row[0].toString()));
      }
      emit(SelectedData("تم جلب الاوقات "));
    }).catchError((error, stackTrace) {
      emit(ErrorSelectingDataState('[getTime] $error'));
      print("Owis getTime :($error) \n $stackTrace");
    });
  }

  Future<void> getReservation(DateTime date, String type) async {
    emit(LoadingState());
    MyData.reservationList.clear();
    print("$date _ $type");
    await _myDB!.query('''
        select temp_reservation_id, user_id, user_name ,user_address,temp_reservation_type
    from user,temp_reservation
    where temp_reservation_user_id=user_id 
    and temp_reservation_trip_type=?
    and temp_reservation_date=?
    ;
    ''', [type.trim(), date.toUtc()]).then((value) {
      print(value);
      for (var row in value) {
        Reservation r = Reservation.fromDB(row);
        MyData.reservationList[r.id] = r;
      }
      emit(SelectedData("تم جلب بيانات الحجوزات"));
    }).catchError((error, stackTrace) {
      emit(ErrorSelectingDataState('[getReservation] $error'));
      print("Owis getReservation :($error) \n $stackTrace");
    });
  }
}
