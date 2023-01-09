import 'package:flutter/material.dart';
import 'package:semesterial_project_admin/Models/manager.dart';
import 'package:semesterial_project_admin/MyCubit/myData.dart';
import '../MyCubit/app_cubit.dart';
import '../Components/button.dart';
import '../Components/dialog.dart';
import '../Components/forms_items.dart';
import '../Components/scaffold.dart';
import '../Screens/driver_management_screen.dart';
import '../Screens/trip_management_screen.dart';
import '../Screens/user_management_screen.dart';
import 'package:smart_grid_view_nls/smart_grid_view_nls.dart';
import 'bus_management_screen.dart';
import 'reservation_management_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return myScaffold(
      context: context,
      header: myAppBar(title: 'الشاشة الرئيسية', context: context),
      body: SmartGridView(
        tileWidth: 150,
        tileHeight: 150,
        padding: const EdgeInsets.all(8.0),
        children: [
          clickableGridTile('إدارة السائقين', 'assets/icons/driver.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DriverManagementScreen()),
            );
          }),
          clickableGridTile('إدارة الرحلات', 'assets/icons/trip.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TripManagerScreen()),
            );
          }),
          clickableGridTile('إدارة الزبائن', 'assets/icons/client.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserManagementScreen()),
            );
          }),
          clickableGridTile('إدارة الباصات', 'assets/icons/bus.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BusManagementScreen()),
            );
          }),
          clickableGridTile('إدارة الحجوزات', 'assets/icons/processing.png', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReservationManagementScreen()),
            );
          }),
          clickableGridTile('الملف الشخصي', 'assets/icons/profile.png', () {
            showProfileDialog(context);
          }),
          clickableGridTile('الملاحظات', 'assets/icons/notes.png', null),
        ],
      ),
    );

    /*return BlocConsumer<AppCubit, AppStates>(
      listener: ((context, state) {
        if (state.type == StateType.successState) {
          mySnackBar(state.toString(), context, Colors.green, Colors.white);
        } else {
          mySnackBar(state.toString(), context, Colors.red, Colors.black);
        }
      }),
      builder: (context, state) {
        return myScaffold(
          context: context,
          header: myAppBar(title: 'الشاشة الرئيسية', context: context),
          body: SmartGridView(
            tileWidth: 150,
            tileHeight: 150,
            padding: const EdgeInsets.all(8.0),
            children: [
              _clickableGridTile('إدارة السائقين', 'assets/icons/driver.png', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DriverManagementScreen()),
                );
              }),
              _clickableGridTile('إدارة الرحلات', 'assets/icons/trip.png', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TripManagerScreen()),
                );
              }),
              _clickableGridTile('إدارة الزبائن', 'assets/icons/client.png', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserManagementScreen()),
                );
              }),
              _clickableGridTile('إدارة الباصات', 'assets/icons/bus.png', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BusManagementScreen()),
                );
              }),
              _clickableGridTile('إدارة الحجوزات', 'assets/icons/processing.png', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReservationManagementScreen()),
                );
              }),
              _clickableGridTile('الملف الشخصي', 'assets/icons/profile.png', () {
                showProfileDialog(context);
              }),
              _clickableGridTile('الملاحظات', 'assets/icons/notes.png', null),
            ],
          ),
        );
      },
    );*/
  }

  void showProfileDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final phoneNumberController = TextEditingController();
    AppCubit myDB = AppCubit.get(context);
    final formKey = GlobalKey<FormState>();
    await myDB.getManager();
    nameController.text = MyData.manager!.name;
    phoneNumberController.text = MyData.manager!.phone;
    final int managerId = MyData.manager!.id;
    myDialog(
        context: context,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'ملفي الشخصي',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    defaultTextFormField(
                      controller: nameController,
                      myHintText: 'اسمي',
                      typeOfKeyboard: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "يجب ادخال الاسم ";
                        }
                        return null;
                      },
                    ),
                    defaultTextFormField(
                      controller: phoneNumberController,
                      myHintText: 'رقم الهاتف',
                      typeOfKeyboard: TextInputType.number,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "يجب ادخال رقم الهاتف";
                        }
                        return null;
                      },
                    ),
                    myNormalButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            Manager m = Manager(
                                id: managerId,
                                name: nameController.text,
                                phone: phoneNumberController.text);
                            await myDB.updateManager(m);
                            Navigator.pop(context);
                          }
                        },
                        title: 'احفظ',
                        icon: Icons.save_outlined)
                  ],
                ))
          ],
        ));
  }
}
