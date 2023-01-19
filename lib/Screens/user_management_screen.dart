import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Components/card.dart';
import '../Components/error.dart';
import '../Components/loading.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';
import '../Models/user.dart';
import '../Backend/DB/database.dart';
import '../Backend/DB/db_states.dart';
import '../Backend/DB/myData.dart';
import '../Screens/user_trips_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  void initState() {
    Database.get(context).getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Database myDB = Database.get(context);

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
        body: BlocBuilder<Database, DatabaseStates>(
          builder: (context, state) {
            List<int> myKeys = MyData.userList.keys.toList();
            if (state is LoadingState) {
              return myLoading();
            } else if (state is ErrorSelectingDataState) {
              return myError(
                  msg: state.msg,
                  onPressed: () {
                    myDB.getUser();
                  });
            } else {
              return ListView.builder(
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
                          MaterialPageRoute(
                              builder: (context) => UserTripsScreen(
                                user: user,
                              )),
                        );
                      });
                },
              );
            }
          },
        ));
  }
}
