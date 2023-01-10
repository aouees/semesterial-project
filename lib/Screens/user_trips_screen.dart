import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Components/loading.dart';
import '../Models/trip.dart';
import '../Models/user.dart';
import '../Backend/DB/myData.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';

import '../Components/card.dart';
import '../Backend/DB/database.dart';
import '../Backend/DB/db_states.dart';

class UserTripsScreen extends StatelessWidget {
  const UserTripsScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    Database myDB = Database.get(context);
    return myScaffold(
        context: context,
        header: myAppBar(
            title: 'حجوزات ${user.userName}',
            context: context,
            rightButton: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_forward_ios))),
        body: BlocConsumer<Database, DatabaseStates>(
          listener: (context, state) {
            if (state is ErrorSelectingDataState) {
              // mySnackBar(state.toString(), context, Colors.red, Colors.black);
              myDB.getUserTrips(user);
            } /*else if (state is ErrorUpdatingDataState ||
                state is ErrorDeletingDataState ||
                state is ErrorInsertingDataState) {
              mySnackBar(state.toString(), context, Colors.red, Colors.black);
            } else {
              mySnackBar(state.toString(), context, Colors.green, Colors.white);
            }*/
          },
          builder: (context, state) {
            List<int> myKeys = MyData.tripList.keys.toList();
            if (state is LoadingState) {
              return myLoading();
            } else {
              return ListView.builder(
                itemCount: MyData.tripList.length,
                itemBuilder: (context, index) {
                  Trip trip = MyData.tripList[myKeys[index]]!;
                  return myCard(values: [
                    myValues('الرحلة', trip.tripName),
                    myValues('التاريخ', trip.tripDate),
                    myValues('الوقت', trip.tripTime),
                    myValues('نوع الرحلة', trip.tripType),
                    myValues('سعر الحجز', trip.price.toString()),
                  ], actions: [
                    IconButton(
                        onPressed: () {
                          myDB.deleteUserRes(user, trip);
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
        footer: Container(
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
        ));
  }
}
