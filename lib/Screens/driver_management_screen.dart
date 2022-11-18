import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Components/button.dart';
import '../Components/dialog.dart';
import '../Components/scaffold.dart';
import '../Components/snack_bar.dart';
import '../Constants/colors.dart';

import '../Components/card.dart';
import '../Components/forms_items.dart';
import '../MyCubit/app_cubit.dart';
import '../MyCubit/app_states.dart';

class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({Key? key}) : super(key: key);

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen> {
  final _nameController = TextEditingController();

  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SuccessState) {
          mySnackBar(state.toString(), context, Colors.green, Colors.white);
        } else {
          mySnackBar(state.toString(), context, Colors.red, Colors.black);
        }
      },
      builder: (context, state) {
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
            body: SingleChildScrollView(
              child: Column(
                  children: List.generate(
                10,
                (index) => myCard(values: [
                  myValues('الاسم', 'ابو محمد'),
                  myValues('رقم الهاتف', '0974621589'),
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
                onPressed: () {
                  showDriverDialog(context);
                },
                title: 'إضافة سائق جديد',
                icon: Icons.add));
      },
    );
  }

  void showDriverDialog(BuildContext context) {
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
