import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semesterial_project_admin/MyCubit/app_cubit.dart';
import 'package:semesterial_project_admin/MyCubit/app_states.dart';
import '../Components/scaffold.dart';

import '../Components/button.dart';
import '../Components/card.dart';
import '../Components/dialog.dart';
import '../Components/forms_items.dart';
import '../Components/snack_bar.dart';
import '../Constants/colors.dart';
import '../Models/bus.dart';
import '../MyCubit/myData.dart';
import 'wait_screen.dart';

class BusManagementScreen extends StatefulWidget {
  const BusManagementScreen({Key? key}) : super(key: key);

  @override
  State<BusManagementScreen> createState() => _BusManagementScreenState();
}

class _BusManagementScreenState extends State<BusManagementScreen> {
  final _typeController = TextEditingController();
  final _numberSeatsController = TextEditingController();
  final _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getBus();
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
          myDB.getBus();
        }
        if (state is SelectingData) {
          return const WaitScreen();
        }
        List<int> myKeys = MyData.busList.keys.toList();
        return myScaffold(
          context: context,
          header: myAppBar(
              title: 'ادارة الباصات',
              context: context,
              rightButton: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_forward_ios))),
          body: ListView.builder(
            itemCount: MyData.busList.length,
            itemBuilder: (context, index) {
              Bus bus = MyData.busList[myKeys[index]]!;
              return myCard(values: [
                myValues('النوع', bus.busType),
                myValues('رقم اللوحة', '${bus.busNumber}'),
                myValues('عدد المقاعد', '${bus.busSeats}'),
              ], actions: [
                IconButton(
                    onPressed: () {
                      myDB.deleteBus(bus);
                    },
                    color: MyColors.blue,
                    icon: const Icon(Icons.delete_forever)),
                IconButton(
                    onPressed: () {
                      _typeController.text = bus.busType;
                      _numberSeatsController.text = '${bus.busSeats}';
                      _numberController.text = '${bus.busNumber}';
                      showBusDialog(context: context, oldBus: bus);
                    },
                    color: MyColors.blue,
                    icon: const Icon(Icons.edit)),
              ]);
            },
          ),
          footer: myGradiantButton(
            context: context,
            title: 'اضافة باص جديد',
            icon: Icons.add,
            onPressed: () {
              showBusDialog(context: context);
            },
          ),
        );
      },
    );
  }

  void showBusDialog({required BuildContext context, Bus? oldBus}) {
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
                    'إضافة باص جديد',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                defaultTextFormField(
                  controller: _typeController,
                  myHintText: 'نوع الباص',
                  typeOfKeyboard: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "يجب ادخال نوع الباص ";
                    }
                    return null;
                  },
                ),
                defaultTextFormField(
                  controller: _numberController,
                  myHintText: 'رقم اللوحة',
                  typeOfKeyboard: TextInputType.number,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "يجب ادخال رقم لوحة الباص";
                    }
                    return null;
                  },
                ),
                defaultTextFormField(
                  controller: _numberSeatsController,
                  myHintText: 'عدد المقاعد الكلي',
                  typeOfKeyboard: TextInputType.number,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "يجب ادخال عدد المقاعد الكلي";
                    }
                    return null;
                  },
                ),
                myNormalButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Bus newBus = Bus(
                            busNumber: int.parse(_numberController.text),
                            busSeats: int.parse(_numberSeatsController.text),
                            busType: _typeController.text);
                        if (oldBus == null) {
                          myDB.insertBus(newBus);
                        } else {
                          newBus.busId = oldBus.busId;
                          myDB.updateBus(newBus);
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
