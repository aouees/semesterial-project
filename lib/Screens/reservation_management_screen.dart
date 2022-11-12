import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import '../Components/button.dart';
import '../Components/card.dart';
import '../Components/dialog.dart';
import '../Components/forms_items.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';

class ReservationManagementScreen extends StatefulWidget {
  const ReservationManagementScreen({Key? key}) : super(key: key);

  @override
  State<ReservationManagementScreen> createState() =>
      _ReservationManagementScreenState();
}

class _ReservationManagementScreenState
    extends State<ReservationManagementScreen> {
  var _timeController = DropdownEditingController<String>();
  var _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Column(
              children: List.generate(10, (index) {
            var timeArrivedController = TextEditingController();
            var tripController = TextEditingController();
            return myCard(values: [
              myValues('الاسم', 'ابو محمد'),
              myValues('العنوان', 'ام الطنافس'),
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
                                      foregroundColor:
                                          MyColors.blue, // button text color
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
              myNormalButton(
                  onPressed: () {}, title: 'احفظ', icon: Icons.save_outlined)
            ]);
          })),
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
    myDialog(
      context: context,
      body: Form(
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
                                  foregroundColor:
                                      MyColors.blue, // button text color
                                ),
                              ),
                            ),
                            child: child ?? Container(),
                          );
                        },
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 7)))
                    .then((value) {
                  if (value != null) {
                    var actDate = '${value.day}/${value.month}/${value.year}';
                    _dateController.text = actDate;
                    setState(() {});
                  }
                });
              }),
          mySmallDropDown(
              validate: (value) {
                if (value!.isEmpty) {
                  return "يجب اختيار الوقت ";
                }
                return null;
              },
              options: [
                "8:00",
                "10:00",
                "12:00",
                "2:00",
                "4:00",
              ],
              label: "اختر الوقت",
              controller: _timeController),
          myNormalButton(
              onPressed: () {
                Navigator.pop(context);
              },
              title: 'تم',
              icon: Icons.check_rounded)
        ],
      )),
    );
  }
}
