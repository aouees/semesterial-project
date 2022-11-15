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
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        mySnackBar(state.toString(), context);
      },
      builder: (context, state) {
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
          body: SingleChildScrollView(
            child: Column(
                children: List.generate(
              10,
              (index) => myCard(values: [
                myValues('النوع', 'كيا'),
                myValues('رقم اللوحة', '456482'),
                myValues('عدد المقاعد', '25'),
              ], actions: [
                IconButton(
                    onPressed: () {},
                    color: MyColors.blue,
                    icon: const Icon(Icons.delete_forever)),
                IconButton(
                    onPressed: () {},
                    color: MyColors.blue,
                    icon: const Icon(Icons.edit)),
              ]),
            )),
          ),
          footer: myGradiantButton(
            context: context,
            title: 'اضافة باص جديد',
            icon: Icons.add,
            onPressed: () {
              AppCubit.get(context).emit(InitialState());
              showBusDialog(context);
            },
          ),
        );
      },
    );
  }

  void showBusDialog(BuildContext context) {
    myDialog(
        context: context,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'إضافة سائق جديد',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Form(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
