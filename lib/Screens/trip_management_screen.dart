import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semesterial_project_admin/Backend/DB/myData.dart';
import 'package:semesterial_project_admin/Components/loading.dart';
import 'package:semesterial_project_admin/Models/trip.dart';
import '../Components/button.dart';
import '../Components/dialog.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';
import '../Backend/DB/database.dart';
import '../Backend/DB/db_states.dart';
import '../Screens/add_trip_form_Screen.dart';

import '../Components/card.dart';

class TripManagerScreen extends StatefulWidget {
  const TripManagerScreen({Key? key}) : super(key: key);

  @override
  State<TripManagerScreen> createState() => _TripManagerScreenState();
}

class _TripManagerScreenState extends State<TripManagerScreen> {
  @override
  void initState() {
    Database.get(context).getTrips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Database myDB = Database.get(context);
    return DefaultTabController(
        length: 2,
        child: myScaffold(
            context: context,
            header: Container(
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15,
                ),
              ], borderRadius: BorderRadius.circular(50), color: Colors.white),
              margin: const EdgeInsets.all(15),
              height: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 0.09 * MediaQuery.of(context).size.height
                  : 0.07 * MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  const Expanded(
                    child: TabBar(
                        labelColor: MyColors.blue,
                        unselectedLabelColor: MyColors.gray,
                        labelPadding: EdgeInsets.all(5.0),
                        indicatorColor: MyColors.blue,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 4.0,
                        labelStyle: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                        ),
                        tabs: [
                          Text('الرحلات القادمة'),
                          Text('الرحلات الفائتة'),
                        ]),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_forward_ios)),
                ],
              ),
            ),
            body: BlocConsumer<Database, DatabaseStates>(
              listener: (context, state) {},
              builder: (context, state) {
                List<int> myKeys = MyData.tripList.keys.toList();
                List<int> myKeysOnPast = MyData.tripListOnPast.keys.toList();
                if (state is LoadingState) {
                  return myLoading();
                }
                return TabBarView(
                  children: [
                    ListView.builder(
                      itemCount: MyData.tripList.length,
                      itemBuilder: (context, index) {
                        Trip trip = MyData.tripList[myKeys[index]]!;
                        return myCard(
                            values: [
                              myValues('اسم الرحلة', trip.tripName),
                              myValues('الساعة', trip.tripTime),
                              myValues('التاريخ', trip.tripDate),
                              myValues('نوع الرحلة', trip.tripType)
                            ],
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    myDB.deleteTrip(trip);
                                  },
                                  color: MyColors.blue,
                                  icon: const Icon(Icons.delete_forever)),
                            ],
                            onClick: () {
                              showTripDialog(context, trip);
                            });
                      },
                    ),
                    ListView.builder(
                      itemCount: MyData.tripListOnPast.length,
                      itemBuilder: (context, index) {
                        Trip trip = MyData.tripListOnPast[myKeysOnPast[index]]!;
                        return myCard(
                            values: [
                              myValues('اسم الرحلة', trip.tripName),
                              myValues('الساعة', trip.tripTime),
                              myValues('التاريخ', trip.tripDate),
                              myValues('نوع الرحلة', trip.tripType)
                            ],
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    myDB.deleteTrip(trip);
                                  },
                                  color: MyColors.blue,
                                  icon: const Icon(Icons.delete_forever)),
                            ],
                            onClick: () {
                              showTripDialog(context, trip);
                            });
                      },
                    ),
                  ],
                );
              },
            ),
            footer: myGradiantButton(
                context: context,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTripForm()),
                  );
                },
                title: 'اضافة رحلة جديدة',
                icon: Icons.add)));
  }

  void showTripDialog(BuildContext context, Trip trip) {
    myDialog(
        context: context,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            myValues('اسم الرحلة', trip.tripName),
            myValues('الساعة', trip.tripTime),
            myValues('التاريخ', trip.tripDate),
            myValues('نوع الرحلة', trip.tripType),
            myValues('الباص', trip.busDetails),
            myValues('السائق', trip.driverDetails),
            myNormalButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                title: 'تم',
                icon: Icons.check_rounded)
          ],
        ));
  }
}
