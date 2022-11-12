import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import '../Components/button.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';

import '../Components/forms_items.dart';

class AddTripForm extends StatefulWidget {
  const AddTripForm({Key? key}) : super(key: key);

  @override
  State<AddTripForm> createState() => _AddTripFormState();
}

class _AddTripFormState extends State<AddTripForm> {
  final _nameController = TextEditingController();
  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  final _typeController = TextEditingController();
  final _driverController = TextEditingController();
  final _busController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return myScaffold(
        context: context,
        header: myAppBar(
            title: 'اضافة رحلة جديدة',
            context: context,
            rightButton: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_forward_ios))),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
              ),
            ], borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  defaultTextFormField(
                    controller: _nameController,
                    myHintText: 'اسم الرحلة',
                    typeOfKeyboard: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "يجب ادخال اسم الرحلة ";
                      }
                      return null;
                    },
                  ),
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
                          _timeController.text = actTime;
                          setState(() {});
                        }
                      });
                    },
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
                                        primary:
                                            MyColors.blue, // body text color
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: MyColors
                                              .blue, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child ?? Container(),
                                  );
                                },
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(const Duration(days: 7)))
                            .then((value) {
                          if (value != null) {
                            var actDate =
                                '${value.day}/${value.month}/${value.year}';
                            _dateController.text = actDate;
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
                              SelectedListItem(
                                  name: 'ذهاب الى الجامعة', value: '0'),
                              SelectedListItem(
                                  name: 'العودة من الجامعة', value: '1'),
                            ],
                            context: context);
                      }),
                  defaultTextFormField(
                      controller: _driverController,
                      myHintText: 'السائق',
                      typeOfKeyboard: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "يجب اختيار السائق ";
                        }
                        return null;
                      },
                      readonly: true,
                      onTap: () {
                        myBigDropdown(
                            title: 'اختر السائق',
                            controller: _driverController,
                            itemList: <SelectedListItem>[
                              SelectedListItem(name: 'محمد', value: '0'),
                              SelectedListItem(name: 'تحسين', value: '1'),
                              SelectedListItem(name: 'محمد', value: '0'),
                              SelectedListItem(name: 'تحسين', value: '1'),
                              SelectedListItem(name: 'محمد', value: '0'),
                              SelectedListItem(name: 'تحسين', value: '1'),
                            ],
                            context: context);
                      }),
                  defaultTextFormField(
                      controller: _busController,
                      myHintText: 'الباص',
                      typeOfKeyboard: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "يجب اختيار الباص ";
                        }
                        return null;
                      },
                      readonly: true,
                      onTap: () {
                        myBigDropdown(
                            title: 'اختر الباص',
                            controller: _busController,
                            itemList: <SelectedListItem>[
                              SelectedListItem(name: 'كيا 2000', value: '0'),
                              SelectedListItem(name: 'هونداي 98', value: '1'),
                              SelectedListItem(name: 'كيا 2000', value: '0'),
                              SelectedListItem(name: 'هونداي 98', value: '1'),
                            ],
                            context: context);
                      }),
                  myNormalButton(
                      onPressed: () {},
                      title: 'اضافة',
                      icon: Icons.save_outlined)
                ],
              )),
            ),
          ),
        ));
  }
}
