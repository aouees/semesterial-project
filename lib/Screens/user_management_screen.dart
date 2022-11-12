import 'package:flutter/material.dart';
import '../Components/card.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';
import '../Screens/user_trips_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  Widget build(BuildContext context) {
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
          leftButton:
              IconButton(onPressed: () {}, icon: const Icon(Icons.search))),
      body: SingleChildScrollView(
        child: Column(
            children: List.generate(
          10,
          (index) => myCard(
              values: [
                myValues('الاسم', 'محمد الحسن'),
                myValues('رقم الهاتف', '0974621589'),
                myValues('العنوان', 'باب شرقي'),
              ],
              actions: [
                IconButton(
                    onPressed: () {},
                    color: MyColors.blue,
                    icon: const Icon(Icons.delete_forever)),
              ],
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserTripsScreen()),
                );
              }),
        )),
      ),
    );
  }
}
