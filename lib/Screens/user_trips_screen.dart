import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Components/error.dart';
import '../Components/loading.dart';
import '../Models/trip.dart';
import '../Models/user.dart';
import '../Backend/DB/myData.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';

import '../Components/card.dart';
import '../Backend/DB/database.dart';
import '../Backend/DB/db_states.dart';

class UserTripsScreen extends StatefulWidget {
  const UserTripsScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<UserTripsScreen> createState() => _UserTripsScreenState();
}

class _UserTripsScreenState extends State<UserTripsScreen> {
  @override
  void initState() {
    Database.get(context).getUserTrips(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Database myDB = Database.get(context);
    return myScaffold(
        context: context,
        header: myAppBar(
            title: 'حجوزات ${widget.user.userName}',
            context: context,
            rightButton: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_forward_ios))),
        body: BlocBuilder<Database, DatabaseStates>(
          builder: (context, state) {
            List<int> myKeys = MyData.tripList.keys.toList();
            if (state is LoadingState) {
              return myLoading();
            } else if (state is ErrorSelectingDataState) {
              return myError(
                  msg: state.msg,
                  onPressed: () {
                    myDB.getUserTrips(widget.user);
                  });
            } else if (MyData.tripList.isEmpty) {
              return onNoDataFound('لا يوجد حجوزات لهذا المستخدم');
            } else {
              return ListView.builder(
                itemCount: MyData.tripList.length,
                itemBuilder: (context, index) {
                  Trip trip = MyData.tripList[myKeys[index]]!;
                  return myCard(values: [
                    myValues('الرحلة', trip.tripName),
                    myValues('الساعة', trip.tripDate.toString().substring(11)),
                    myValues('التاريخ', trip.tripDate.toString().substring(0, 10)),
                    myValues('نوع الرحلة', trip.tripType),
                    myValues('سعر الحجز', trip.price.toString()),
                  ], actions: [
                    IconButton(
                        onPressed: () {
                          myDB.deleteUserRes(widget.user, trip);
                        },
                        color: MyColors.blue,
                        icon: const Icon(
                          Icons.delete_forever,
                        )),
                  ]);
                },
              );
            }
          },
        ),
        footer: BlocBuilder<Database, DatabaseStates>(
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15,
                ),
              ], color: Colors.white),
              height: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 0.09 * MediaQuery.of(context).size.height
                  : 0.07 * MediaQuery.of(context).size.height,
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      myValues('عدد الرحلات', '${MyData.tripList.length}'),
                      myValues('المبلغ الكلي', '${MyData.totalAmount}'),
                    ],
                  )),
            );
          },
        ));
  }
}
