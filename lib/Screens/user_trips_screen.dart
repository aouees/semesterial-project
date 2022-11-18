import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semesterial_project_admin/Components/snack_bar.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';

import '../Components/card.dart';
import '../MyCubit/app_cubit.dart';
import '../MyCubit/app_states.dart';

class UserTripsScreen extends StatefulWidget {
  const UserTripsScreen({Key? key}) : super(key: key);

  @override
  State<UserTripsScreen> createState() => _UserTripsScreenState();
}

class _UserTripsScreenState extends State<UserTripsScreen> {
  final TextEditingController _searchController = TextEditingController();

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
        return myScaffold(
            context: context,
            header: myAppBar(
                title: 'حجوزات الزبون',
                context: context,
                rightButton: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_forward_ios))),
            body: SingleChildScrollView(
              child: Column(
                  children: List.generate(
                10,
                (index) => myCard(values: [
                  myValues('الرحلة', 'محمد الحسن'),
                  myValues('التاريخ', '5-5-2020'),
                  myValues('الوقت', '8:00'),
                  myValues('نوع الرحلة', 'ذهاب'),
                ], actions: [
                  IconButton(
                      onPressed: () {},
                      color: MyColors.blue,
                      icon: const Icon(
                        Icons.delete_forever,
                      )),
                ]),
              )),
            ),
            footer: Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15,
                ),
              ], color: Colors.white),
              height:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 0.09 * MediaQuery.of(context).size.height
                      : 0.07 * MediaQuery.of(context).size.height,
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Center(child: myValues('عدد الرحلات', '15'))),
            ));
      },
    );
  }
}
