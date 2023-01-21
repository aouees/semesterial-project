import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semesterial_project_admin/Models/reservation.dart';
import '../Backend/DB/myData.dart';
import '../Components/button.dart';
import '../Components/card.dart';
import '../Components/dialog.dart';
import '../Components/forms_items.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';
import '../Backend/DB/database.dart';
import '../Backend/DB/db_states.dart';

class ReservationManagementScreen extends StatefulWidget {
  const ReservationManagementScreen({Key? key}) : super(key: key);

  @override
  State<ReservationManagementScreen> createState() => _ReservationManagementScreenState();
}

class _ReservationManagementScreenState extends State<ReservationManagementScreen> {
  final _timeController = TextEditingController();
  final _typeController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Database myDB = Database.get(context);

    return myScaffold(
        context: context,
        header: myAppBar(
          title: 'إدارة الحجوزات',
          context: context,
          rightButton: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_forward_ios)),
        ),
        body: BlocBuilder<Database, DatabaseStates>(
          builder: (context, state) {
            List<int> myKeys = MyData.reservationList.keys.toList();

            return ListView.builder(
              itemCount: MyData.reservationList.length,
              itemBuilder: (context, index) {
                Reservation r = MyData.reservationList[myKeys[index]]!;
                var tripController = TextEditingController(),
                    timeArrivedController = TextEditingController();
                return myCard(values: [
                  myValues('الاسم', r.username),
                  myValues('العنوان', r.address),
                  defaultTextFormField(
                      controller: tripController,
                      myHintText: 'اختر الرحلة المناسبة',
                      typeOfKeyboard: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "يجب اختيار الرحلة ";
                        }
                        return null;
                      },
                      readonly: true,
                      onTap: () {
                        myBigDropdown(
                            title: 'اختر الرحلة',
                            controller: tripController,
                            itemList: <SelectedListItem>[
                              SelectedListItem(name: 'الرحلة الاولى', value: '0'),
                              SelectedListItem(name: 'الرحلة الثانية', value: '1'),
                              SelectedListItem(name: 'الرحلة الثالثة', value: '2'),
                            ],
                            context: context);
                      }),
                  defaultTextFormField(
                      controller: timeArrivedController,
                      myHintText: 'حدد وقت وصول الباص',
                      typeOfKeyboard: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "يجب تحديد وقت وصول الباصل ";
                        }
                        return null;
                      },
                      readonly: true,
                      onTap: () {
                        showTimePicker(
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: MyColors.blue, // body text color
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: MyColors.blue, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child ?? Container(),
                                  );
                                },
                                context: context,
                                initialTime: TimeOfDay.now())
                            .then((value) {
                          if (value != null) {
                            var actTime = "${value.hour}:${value.minute}";
                            timeArrivedController.text = actTime;
                          }
                        });
                      }),
                  myNormalButton(onPressed: () {}, title: 'احفظ', icon: Icons.save_outlined)
                ]);
              },
            );
          },
        ),
        footer: myGradiantButton(
            context: context,
            onPressed: () {
              showFilterDialog(context);
            },
            title: 'فلترة حسب اليوم والوقت',
            icon: Icons.filter_alt));
  }

  void showFilterDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    Database myDB = Database.get(context);
    myDialog(
      context: context,
      body: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  'فلترة الحجوزات',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              defaultTextFormField(
                  controller: _dateController,
                  myHintText: 'التاريخ',
                  typeOfKeyboard: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "يجب ادخال التاريخ ";
                    }
                    return null;
                  },
                  readonly: true,
                  onTap: () {
                    showDatePicker(
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: MyColors.blue, // body text color
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: MyColors.blue, // button text color
                                    ),
                                  ),
                                ),
                                child: child ?? Container(),
                              );
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 6)))
                        .then((value) {
                      if (value != null) {
                        _dateController.text = value.toString().substring(0, 10);
                        setState(() {});
                      }
                    });
                  }),
              defaultTextFormField(
                  controller: _typeController,
                  myHintText: 'نوع الرحلة',
                  typeOfKeyboard: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return "يجب ادخال نوع الرحلة ";
                    }
                    return null;
                  },
                  readonly: true,
                  onTap: () {
                    myBigDropdown(
                        title: 'اختر نوع الرحلة',
                        controller: _typeController,
                        itemList: <SelectedListItem>[
                          SelectedListItem(name: 'ذهاب الى الجامعة', value: 'ذهاب'),
                          SelectedListItem(name: 'العودة من الجامعة', value: 'اياب'),
                        ],
                        context: context);
                  }),
              defaultTextFormField(
                readonly: true,
                controller: _timeController,
                myHintText: 'الساعة',
                typeOfKeyboard: TextInputType.text,
                validate: (value) {
                  if (value!.isEmpty) {
                    return "يجب ادخال الساعة ";
                  }
                  return null;
                },
                onTap: () async {
                  await myDB.getTime();
                  myBigDropdown(
                      title: 'اختر وقت الرحلة',
                      controller: _timeController,
                      itemList: MyData.timeItems,
                      context: context);
                },
              ),
              myNormalButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var time = _timeController.text.split(' _ ')[1].split(':');
                      Duration x = Duration(hours: int.parse(time[0]), minutes: int.parse(time[1]));
                      DateTime t = DateTime.parse(_dateController.text).add(x);
                      print('${t.toUtc()}**$t ** ${_typeController.text.split('_')[0]}.');
                      myDB.getReservation(t, _typeController.text.split('_')[0]);
                      Navigator.pop(context);
                    }
                  },
                  title: 'تم',
                  icon: Icons.check_rounded)
            ],
          )),
    );
  }
}
