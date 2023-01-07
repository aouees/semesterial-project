import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Components/card.dart';
import '../Components/scaffold.dart';
import '../Components/snack_bar.dart';
import '../Constants/colors.dart';
import '../Models/user.dart';
import '../MyCubit/app_cubit.dart';
import '../MyCubit/app_states.dart';
import '../MyCubit/myData.dart';
import '../Screens/user_trips_screen.dart';
import 'wait_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state.type == StateType.successState) {
          mySnackBar(state.toString(), context, Colors.green, Colors.white);
        } else {
          mySnackBar(state.toString(), context, Colors.red, Colors.black);
        }
      },
      builder: (context, state) {
        AppCubit myDB = AppCubit.get(context);
        if (state is SelectedData && state.type == StateType.errorState) {
          myDB.getUser();
        }
        if (state is SelectingData) {
          return const WaitScreen();
        }
        List<int> myKeys = MyData.userList.keys.toList();
        return myScaffold(
            context: context,
            header: myAppBar(
                title: 'إدارة الزبائن',
                context: context,
                rightButton: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
                leftButton: IconButton(onPressed: () {}, icon: const Icon(Icons.search))),
            body: ListView.builder(
              itemCount: MyData.userList.length,
              itemBuilder: (context, index) {
                User user = MyData.userList[myKeys[index]]!;
                return myCard(
                    values: [
                      myValues('الاسم', user.userName),
                      myValues('رقم الهاتف', user.userPhone),
                      myValues('العنوان', user.userAddress),
                    ],
                    actions: [
                      IconButton(
                          onPressed: () {
                            myDB.deleteUser(user);
                          },
                          color: MyColors.blue,
                          icon: const Icon(Icons.delete_forever)),
                    ],
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserTripsScreen()),
                      );
                    });
              },
            ));
      },
    );
  }
}
