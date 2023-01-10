import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semesterial_project_admin/Components/loading.dart';
import '../Backend/DB/myData.dart';
import '../Components/button.dart';
import '../Components/dialog.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';
import '../Components/card.dart';
import '../Components/forms_items.dart';
import '../Models/driver.dart';
import '../Backend/DB/database.dart';
import '../Backend/DB/db_states.dart';

class DriverManagementScreen extends StatelessWidget {
  DriverManagementScreen({Key? key}) : super(key: key);

  final _nameController = TextEditingController();

  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Database myDB = Database.get(context);
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
        body: BlocConsumer<Database, DatabaseStates>(
          listener: (context, state) {
            if (state is ErrorSelectingDataState) {
              //mySnackBar(state.msg, context, Colors.red, Colors.black);
              myDB.getDrivers();
            } /* else if (state is ErrorUpdatingDataState ||
                state is ErrorDeletingDataState ||
                state is ErrorInsertingDataState) {
              mySnackBar(state.msg, context, Colors.red, Colors.black);
            } else {
              mySnackBar(state.msg, context, Colors.green, Colors.white);
            }*/
          },
          builder: (context, state) {
            List<int> myKeys = MyData.driversList.keys.toList();
            if (state is LoadingState) {
              return myLoading();
            } else {
              return ListView.builder(
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
                          showDriverDialog(context: context, oldDriver: driver);
                        },
                        color: MyColors.blue,
                        icon: const Icon(Icons.edit)),
                  ]);
                },
              );
            }
          },
        ),
        footer: myGradiantButton(
            context: context,
            onPressed: () {
              showDriverDialog(context: context);
            },
            title: 'إضافة سائق جديد',
            icon: Icons.add));
  }

  void showDriverDialog({required BuildContext context, Driver? oldDriver}) {
    if (oldDriver == null) {
      _nameController.clear();
      _phoneNumberController.clear();
    } else {
      _nameController.text = oldDriver.driverName;
      _phoneNumberController.text = oldDriver.driverPhone;
    }
    Database myDB = Database.get(context);
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
