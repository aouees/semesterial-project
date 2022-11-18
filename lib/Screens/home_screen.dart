import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../MyCubit/app_cubit.dart';
import '../MyCubit/app_states.dart';
import '../Components/button.dart';
import '../Components/dialog.dart';
import '../Components/forms_items.dart';
import '../Components/scaffold.dart';
import '../Components/snack_bar.dart';
import '../Screens/driver_management_screen.dart';
import '../Screens/trip_management_screen.dart';
import '../Screens/user_management_screen.dart';
import 'package:smart_grid_view_nls/smart_grid_view_nls.dart';
import '../Constants/colors.dart';
import 'bus_management_screen.dart';
import 'reservation_management_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _nameController = TextEditingController();

  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: ((context, state) {
        if (state is SuccessState) {
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
                  MaterialPageRoute(
                      builder: (context) => const DriverManagementScreen()),
                );
              }),
              _clickableGridTile('إدارة الرحلات', 'assets/icons/trip.png', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TripManagerScreen()),
                );
              }),
              _clickableGridTile('إدارة الزبائن', 'assets/icons/client.png', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserManagementScreen()),
                );
              }),
              _clickableGridTile('إدارة الباصات', 'assets/icons/bus.png', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BusManagementScreen()),
                );
              }),
              _clickableGridTile('إدارة الحجوزات', 'assets/icons/processing.png',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReservationManagementScreen()),
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
    );
  }

  Widget _clickableGridTile(
      String title, String pathIcon, void Function()? onPressed) {
    List<Widget> widgets = [];
    if (onPressed == null) {
      widgets.add(Container(
          color: Colors.grey.withOpacity(0.5),
          child: const Center(
              child: Text(
            'Coming soon',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ))));
    }
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: MyColors.blue, width: 4),
          borderRadius: BorderRadius.circular(30)),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        splashColor: MyColors.blue,
        onTap: onPressed,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60,
                    child: Image.asset(pathIcon),
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            onPressed == null
                ? Container(
                    color: MyColors.blue.withOpacity(0.4),
                    child: const Center(
                        child: Text(
                      'Coming soon',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )))
                : Container()
          ],
        ),
      ),
    );
  }

  void showProfileDialog(BuildContext context) {
    AppCubit myDB = AppCubit.get(context);
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    defaultTextFormField(
                      controller: _nameController,
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
                      controller: _phoneNumberController,
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        title: 'احفظ',
                        icon: Icons.save_outlined)
                  ],
                ))
          ],
        ));
  }
}
