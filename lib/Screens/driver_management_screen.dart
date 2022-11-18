import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semesterial_project_admin/MyCubit/myData.dart';
import 'package:semesterial_project_admin/Screens/wait_screen.dart';
import '../Components/button.dart';
import '../Components/dialog.dart';
import '../Components/scaffold.dart';
import '../Components/snack_bar.dart';
import '../Constants/colors.dart';

import '../Components/card.dart';
import '../Components/forms_items.dart';
import '../Models/driver.dart';
import '../MyCubit/app_cubit.dart';
import '../MyCubit/app_states.dart';

class DriverManagementScreen extends StatefulWidget {
  DriverManagementScreen({Key? key}) : super(key: key);

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen> {
  final _nameController = TextEditingController();

  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getDrivers();
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
          myDB.getDrivers();
        }
        if (state is SelectingData) {
          return const WaitScreen();
        }
        List<int> myKeys = MyData.driversList.keys.toList();
        return myScaffold(
            context: context,
            header: myAppBar(
                title: 'إدارة السائقين',
                context: context,
                rightButton: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_forward_ios))),
            body: ListView.builder(
              itemCount: MyData.driversList.length,
              itemBuilder: (context, index) {
                Driver driver = MyData.driversList[myKeys[index]]!;
                return myCard(values: [
                  myValues('الاسم', driver.driverName),
                  myValues('رقم الهاتف', driver.driverPhone),
                ], actions: [
                  IconButton(
                      onPressed: () {
                        myDB.deleteDriver(driver);
                      },
                      color: MyColors.blue,
                      icon: const Icon(Icons.delete_forever)),
                  IconButton(
                      onPressed: () {
                        _nameController.text = driver.driverName;
                        _phoneNumberController.text = driver.driverPhone;
                        showDriverDialog(context: context, oldDriver: driver);
                      },
                      color: MyColors.blue,
                      icon: const Icon(Icons.edit)),
                ]);
              },
            ),
            footer: myGradiantButton(
                context: context,
                onPressed: () {
                  showDriverDialog(context: context);
                },
                title: 'إضافة سائق جديد',
                icon: Icons.add));
      },
    );
  }

  void showDriverDialog({required BuildContext context, Driver? oldDriver}) {
    AppCubit myDB = AppCubit.get(context);
    var formKey = GlobalKey<FormState>();

    myDialog(
        context: context,
        body: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'إضافة سائق جديد',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                defaultTextFormField(
                  controller: _nameController,
                  myHintText: 'اسم السائق',
                  typeOfKeyboard: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "يجب ادخال اسم السائق ";
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
                      if (formKey.currentState!.validate()) {
                        Driver newDriver = Driver(
                            driverName: _nameController.text,
                            driverPhone: _phoneNumberController.text);
                        if (oldDriver == null) {
                          myDB.insertDriver(newDriver);
                        } else {
                          newDriver.driverId = oldDriver.driverId;
                          myDB.updateDriver(newDriver);
                        }
                        Navigator.pop(context);
                      }
                    },
                    title: 'احفظ',
                    icon: Icons.save_outlined)
              ],
            )));
  }
}
