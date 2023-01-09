import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semesterial_project_admin/Components/snack_bar.dart';
import 'package:semesterial_project_admin/Models/trip.dart';
import 'package:semesterial_project_admin/Models/user.dart';
import 'package:semesterial_project_admin/MyCubit/myData.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';

import '../Components/card.dart';
import '../MyCubit/app_cubit.dart';
import '../MyCubit/app_states.dart';
import 'wait_screen.dart';

class UserTripsScreen extends StatefulWidget {
  User user;

  UserTripsScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserTripsScreen> createState() => _UserTripsScreenState();
}

class _UserTripsScreenState extends State<UserTripsScreen> {
  @override
  void initState() {
    AppCubit.get(context).getUserTrips(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit myDB = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state.type == StateType.successState) {
          mySnackBar(state.toString(), context, Colors.green, Colors.white);
        } else {
          mySnackBar(state.toString(), context, Colors.red, Colors.black);
        }
      },
      builder: (context, state) {
        List<int> myKeys = MyData.tripList.keys.toList();
        if (state is SelectingData) {
          return const WaitScreen();
        }
        if (state is SelectedData && state.type == StateType.errorState) {
          myDB.getUser();
        }
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
            body: ListView.builder(
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
                        myDB.deleteUserRes(widget.user, trip);
                      },
                      color: MyColors.blue,
                      icon: const Icon(
                        Icons.delete_forever,
                      )),
                ]);
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
      },
    );
  }
}
