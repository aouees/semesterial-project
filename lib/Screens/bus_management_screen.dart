import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Backend/DB/database.dart';
import '../Backend/DB/db_states.dart';
import '../Components/loading.dart';
import '../Components/scaffold.dart';
import '../Components/button.dart';
import '../Components/card.dart';
import '../Components/dialog.dart';
import '../Components/forms_items.dart';
import '../Constants/colors.dart';
import '../Models/bus.dart';
import '../Backend/DB/myData.dart';

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
    Database.get(context).getBus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Database myDB = Database.get(context);
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
      body: BlocConsumer<Database, DatabaseStates>(
        listener: (context, state) {
          if (state is ErrorSelectingDataState) {
            //  mySnackBar(state.msg, context, Colors.red, Colors.black);
            myDB.getBus();
          } /* else if (state is ErrorUpdatingDataState ||
              state is ErrorDeletingDataState ||
              state is ErrorInsertingDataState) {
            mySnackBar(state.msg, context, Colors.red, Colors.black);
          } else {
            mySnackBar(state.msg, context, Colors.green, Colors.white);
          }*/
        },
        builder: (context, state) {
          List<int> myKeys = MyData.busList.keys.toList();
          if (state is LoadingState) {
            return myLoading();
          }
          return ListView.builder(
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
          );
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
  }

  void showBusDialog({required BuildContext context, Bus? oldBus}) {
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
