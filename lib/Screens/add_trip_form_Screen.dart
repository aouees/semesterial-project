import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:semesterial_project_admin/Backend/DB/database.dart';
import 'package:semesterial_project_admin/Backend/DB/myData.dart';
import 'package:semesterial_project_admin/Components/error.dart';
import '../Backend/DB/db_states.dart';
import '../Components/button.dart';
import '../Components/loading.dart';
import '../Components/scaffold.dart';
import '../Constants/colors.dart';

import '../Components/forms_items.dart';
import '../Models/trip.dart';

class AddTripForm extends StatefulWidget {
  const AddTripForm({Key? key, this.tripId}) : super(key: key);
  final int? tripId;

  @override
  State<AddTripForm> createState() => _AddTripFormState();
}

class _AddTripFormState extends State<AddTripForm> {
  final _nameController = TextEditingController();
  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  final _priceController = TextEditingController();
  final _typeController = TextEditingController();
  final _driverController = TextEditingController();
  final _busController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.tripId != null) {
      Database.get(context).getTripById(widget.tripId!).then((value) {
        setState(() {
          _nameController.text = value.tripName;
          _timeController.text = '  _ ${value.tripDate.toString().substring(11, 16)}';
          _dateController.text = value.tripDate.toString().substring(0, 10);
          _priceController.text = value.price.toString();
          _typeController.text = '${value.tripType} _ ';
          _driverController.text = value.driverDetails;
          _busController.text = value.busDetails;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Database myDB = Database.get(context);
    return myScaffold(
        context: context,
        header: myAppBar(
            title: widget.tripId == null ? '?????????? ???????? ??????????' : '?????????? ???????????? ',
            context: context,
            rightButton: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_forward_ios))),
        body: BlocBuilder<Database, DatabaseStates>(
          builder: (context, state) {
            if (state is LoadingState) {
              return myLoading();
            } else if (state is ErrorSelectingDataState) {
              return myError(
                  msg: state.msg,
                  onPressed: () {
                    if (widget.tripId != null) {
                      myDB.getTripById(widget.tripId!).then((value) {
                        setState(() {
                          _nameController.text = value.tripName;
                          _timeController.text =
                              '  _ ${value.tripDate.toString().substring(11, 16)}';
                          _dateController.text = value.tripDate.toString().substring(0, 10);
                          _priceController.text = value.price.toString();
                          _typeController.text = '${value.tripType} _ ';
                          _driverController.text = value.driverDetails;
                          _busController.text = value.busDetails;
                        });
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  });
            } else {
              return SingleChildScrollView(
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
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextFormField(
                              controller: _nameController,
                              myHintText: '?????? ????????????',
                              typeOfKeyboard: TextInputType.text,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return "?????? ?????????? ?????? ???????????? ";
                                }
                                return null;
                              },
                            ),
                            defaultTextFormField(
                              readonly: true,
                              controller: _timeController,
                              myHintText: '????????????',
                              typeOfKeyboard: TextInputType.text,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return "?????? ?????????? ???????????? ";
                                }
                                return null;
                              },
                              onTap: () async {
                                await myDB.getTime();
                                myBigDropdown(
                                    title: '???????? ?????? ????????????',
                                    controller: _timeController,
                                    itemList: MyData.timeItems,
                                    context: context);
                              },
                            ),
                            defaultTextFormField(
                                controller: _dateController,
                                myHintText: '??????????????',
                                typeOfKeyboard: TextInputType.text,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "?????? ?????????? ?????????????? ";
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
                                myHintText: '?????? ????????????',
                                typeOfKeyboard: TextInputType.text,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "?????? ?????????? ?????? ???????????? ";
                                  }
                                  return null;
                                },
                                readonly: true,
                                onTap: () {
                                  myBigDropdown(
                                      title: '???????? ?????? ????????????',
                                      controller: _typeController,
                                      itemList: <SelectedListItem>[
                                        SelectedListItem(name: '???????? ?????? ??????????????', value: '????????'),
                                        SelectedListItem(name: '???????????? ???? ??????????????', value: '????????'),
                                      ],
                                      context: context);
                                }),
                            defaultTextFormField(
                              controller: _priceController,
                              myHintText: '?????? ????????????',
                              typeOfKeyboard: TextInputType.number,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return "?????? ?????????? ?????? ???????????? ";
                                }
                                return null;
                              },
                            ),
                            defaultTextFormField(
                                controller: _driverController,
                                myHintText: '????????????',
                                typeOfKeyboard: TextInputType.text,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "?????? ???????????? ???????????? ";
                                  }
                                  return null;
                                },
                                readonly: true,
                                onTap: () async {
                                  await myDB.getDrivers();
                                  myBigDropdown(
                                      title: '???????? ????????????',
                                      controller: _driverController,
                                      itemList: MyData.driverItems,
                                      context: context);
                                }),
                            defaultTextFormField(
                                controller: _busController,
                                myHintText: '??????????',
                                typeOfKeyboard: TextInputType.text,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "?????? ???????????? ?????????? ";
                                  }
                                  return null;
                                },
                                readonly: true,
                                onTap: () async {
                                  await myDB.getBus();
                                  myBigDropdown(
                                      title: '???????? ??????????',
                                      controller: _busController,
                                      itemList: MyData.busItems,
                                      context: context);
                                }),
                            myNormalButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    var time = _timeController.text.split(' _ ')[1].split(':');
                                    Duration x = Duration(
                                        hours: int.parse(time[0]), minutes: int.parse(time[1]));
                                    Trip t = Trip(
                                        tripName: _nameController.text,
                                        tripType: _typeController.text,
                                        tripDate: DateTime.parse(_dateController.text).add(x),
                                        price: double.parse(_priceController.text),
                                        busDetails: _busController.text,
                                        driverDetails: _driverController.text);
                                    if (widget.tripId == null) {
                                      myDB.insertTrip(t);
                                    } else {
                                      t.tripId = widget.tripId;
                                      myDB.updateTrip(t);
                                    }

                                    Navigator.pop(context);
                                  }
                                },
                                title: widget.tripId == null ? '??????????' : '??????????',
                                icon: Icons.save_outlined)
                          ],
                        )),
                  ),
                ),
              );
            }
          },
        ));
  }
}
