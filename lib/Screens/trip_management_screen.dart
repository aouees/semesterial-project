import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Components/button.dart';
import '../Components/dialog.dart';
import '../Components/scaffold.dart';
import '../Components/snack_bar.dart';
import '../Constants/colors.dart';
import '../MyCubit/app_cubit.dart';
import '../MyCubit/app_states.dart';
import '../Screens/add_trip_form_Screen.dart';

import '../Components/card.dart';

class TripManagerScreen extends StatefulWidget {
  const TripManagerScreen({Key? key}) : super(key: key);

  @override
  State<TripManagerScreen> createState() => _TripManagerScreenState();
}

class _TripManagerScreenState extends State<TripManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SuccessState) {
          mySnackBar(state.toString(), context, Colors.green, Colors.white);
        } else {
          mySnackBar(state.toString(), context, Colors.red, Colors.black);
        }
      },
      builder: (context, state) {
        return DefaultTabController(
            length: 2,
            child: myScaffold(
                context: context,
                header: Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 15,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  margin: const EdgeInsets.all(15),
                  height: MediaQuery.of(context).orientation ==
                          Orientation.landscape
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
                body: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                          children: List.generate(
                        10,
                        (index) => myCard(
                            values: [
                              myValues('اسم الرحلة', 'الرحلة الاولى'),
                              myValues('الساعة', '8:00'),
                              myValues('التاريخ', '19/2/2022'),
                              myValues('نوع الرحلة', 'ذهاب')
                            ],
                            actions: [
                              IconButton(
                                  onPressed: () {},
                                  color: MyColors.blue,
                                  icon: const Icon(Icons.delete_forever)),
                              IconButton(
                                  onPressed: () {},
                                  color: MyColors.blue,
                                  icon: const Icon(Icons.edit)),
                            ],
                            onClick: () {
                              showTripDialog(context);
                            }),
                      )),
                    ),
                    SingleChildScrollView(
                      child: Column(
                          children: List.generate(
                        5,
                        (index) => myCard(
                            values: [
                              myValues('اسم الرحلة', 'الرحلة الاولى'),
                              myValues('الساعة', '8:00'),
                              myValues('التاريخ', '19/2/2022'),
                              myValues('نوع الرحلة', 'ذهاب')
                            ],
                            actions: [
                              IconButton(
                                  onPressed: () {},
                                  color: MyColors.blue,
                                  icon: const Icon(Icons.delete_forever)),
                              IconButton(
                                  onPressed: () {},
                                  color: MyColors.blue,
                                  icon: const Icon(Icons.edit)),
                            ],
                            onClick: () {
                              showTripDialog(context);
                            }),
                      )),
                    ),
                  ],
                ),
                footer: myGradiantButton(
                    context: context,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddTripForm()),
                      );
                    },
                    title: 'اضافة رحلة جديدة',
                    icon: Icons.add)));
      },
    );
  }

  void showTripDialog(BuildContext context) {
    myDialog(
        context: context,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              myValues('اسم الرحلة', 'الرحلة الاولى'),
              myValues('الساعة', '8:00'),
              myValues('التاريخ', '19/2/2022'),
              myValues('نوع الرحلة', 'ذهاب'),
              myValues('الباص', 'كيا 2000'),
              myValues('السائق', 'احمد الحسن'),
              myNormalButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: 'تم',
                  icon: Icons.check_rounded)
            ],
          ),
        ));
  }
}
