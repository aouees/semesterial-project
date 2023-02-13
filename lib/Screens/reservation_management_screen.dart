import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Components/loading.dart';
import '../Components/error.dart';
import '../Models/reservation.dart';
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
  late DateTime _dateTime;

  late String _type;

  @override
  void dispose() {
    MyData.tripItems.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Database myDB = Database.get(context);

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
          buildWhen: (previous, current) {
            return !(current is LoadingTripState || current is SelectTripState);
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return myLoading();
            }
            if (state is ErrorSelectingDataState) {
              return myError(
                  msg: state.msg,
                  onPressed: () {
                    myDB.getReservation(_dateTime.toUtc(), _type);
                  });
            }
            List<int> myKeys = MyData.reservationList.keys.toList();
            return ListView.builder(
              itemCount: MyData.reservationList.length,
              itemBuilder: (context, index) {
                Reservation r = MyData.reservationList[myKeys[index]]!;
                return Form(
                    key: r.formKey,
                    child: myCard(color: r.type == 1 ? Colors.white60 : Colors.white, values: [
                      myValues('الاسم', r.username),
                      myValues('العنوان', r.address),
                      defaultTextFormField(
                          controller: r.tripController,
                          myHintText: 'اختر الرحلة المناسبة',
                          typeOfKeyboard: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "يجب اختيار الرحلة ";
                            }
                            return null;
                          },
                          readonly: true,
                          onTap: () async {
                            await myDB.getTripsByDateType(_dateTime.toUtc(), _type);
                            myBigDropdown(
                              title: 'اختر الرحلة',
                              controller: r.tripController,
                              itemList: MyData.tripItems,
                              context: context,
                            );
                          }),
                      defaultTextFormField(
                          controller: r.timeController,
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
                                    initialTime: TimeOfDay.fromDateTime(_dateTime))
                                .then((value) {
                              if (value != null) {
                                var actTime = "${value.hour}:${value.minute}";
                                r.timeController.text = actTime;
                              }
                            });
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          myNormalButton(
                              onPressed: () {
                                if (r.formKey.currentState!.validate()) {
                                  int tId = int.parse(r.tripController.text.split('_')[0].trim());
                                  var time = r.timeController.text.split(':');
                                  Duration d = Duration(
                                      hours: int.parse(time[0]), minutes: int.parse(time[1]));
                                  myDB.insertReservation(tId, r.userId, d, r.type, r.id,
                                      _dateTime.add(const Duration(days: 7)).toUtc());
                                }
                              },
                              title: 'احفظ',
                              icon: Icons.save_outlined),
                          myNormalButton(
                              onPressed: () {
                                myDB.insertCancelReservation(
                                    r.type, r.id, _dateTime.add(Duration(days: 7)).toUtc());
                              },
                              title: 'حذف',
                              icon: Icons.delete)
                        ],
                      )
                    ]));
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
    final timeController = TextEditingController();
    final typeController = TextEditingController();
    final dateController = TextEditingController();
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
                  controller: dateController,
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
                        dateController.text = value.toString().substring(0, 10);
                      }
                    });
                  }),
              defaultTextFormField(
                  controller: typeController,
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
                        controller: typeController,
                        itemList: <SelectedListItem>[
                          SelectedListItem(name: 'ذهاب الى الجامعة', value: 'ذهاب'),
                          SelectedListItem(name: 'العودة من الجامعة', value: 'اياب'),
                        ],
                        context: context);
                  }),
              defaultTextFormField(
                readonly: true,
                controller: timeController,
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
                      controller: timeController,
                      itemList: MyData.timeItems,
                      context: context);
                },
              ),
              myNormalButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var time = timeController.text.split(' _ ')[1].split(':');
                      Duration x = Duration(hours: int.parse(time[0]), minutes: int.parse(time[1]));
                      _dateTime = DateTime.parse(dateController.text).add(x);
                      _type = typeController.text.split('_')[0].trim();
                      myDB.getReservation(_dateTime.toUtc(), _type);
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
