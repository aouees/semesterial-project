import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semesterial_project_admin/Components/scaffold.dart';

import '../Components/snack_bar.dart';
import '../MyCubit/app_cubit.dart';
import '../MyCubit/app_states.dart';

class WaitScreen extends StatelessWidget {
  const WaitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      if (state.type == StateType.successState) {
        mySnackBar(state.toString(), context, Colors.green, Colors.white);
      } else {
        mySnackBar(state.toString(), context, Colors.red, Colors.black);
      }
    }, builder: (context, state) {
      return myScaffold(
          context: context,
          body: Center(
            child: Image.asset(
              "assets/waiting.gif",
            ),
          ));
    });
  }
}
