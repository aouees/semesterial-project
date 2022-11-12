import 'package:flutter/material.dart';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:dropdown_plus/dropdown_plus.dart';

import '../Constants/colors.dart';

void myBigDropdown({
  required TextEditingController controller,
  required BuildContext context,
  required List<SelectedListItem> itemList,
  String? title,
}) {
  DropDownState(
    DropDown(
      data: itemList,
      bottomSheetTitle: Center(
        child: Text(
          title!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      enableMultipleSelection: false,
      selectedItems: (List<dynamic> selectedList) {
        List<String> list = [];
        for (var item in selectedList) {
          if (item is SelectedListItem) {
            list.add(item.name);
          }
          controller.text = list[0].toString();
        }
      },
    ),
  ).showModal(context);
}

Widget defaultTextFormField({
  required TextEditingController controller,
  required String myHintText,
  required TextInputType typeOfKeyboard,
  required String? Function(String?) validate,
  IconData? suffixIcon,
  bool isPassword = false,
  IconData? prefix,
  Function? onSubmit,
  Function? onTap,
  Function? prefixPressed,
  TextAlign myTextAlign = TextAlign.start,
  bool? idAddressSelected,
  bool readonly = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 5.0,
    ),
    child: TextFormField(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      readOnly: readonly,
      controller: controller,
      textAlign: myTextAlign,
      keyboardType: typeOfKeyboard,
      validator: validate,
      obscureText: isPassword,
      decoration: InputDecoration(
        suffixIcon: suffixIcon != null
            ? Icon(
                suffixIcon,
              )
            : null,
        prefixIcon: prefix != null
            ? IconButton(
                onPressed: () {
                  prefixPressed!();
                },
                icon: Icon(
                  prefix,
                ),
              )
            : null,
        hintText: myHintText,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0XFF7fbcd2),
            style: BorderStyle.solid,
            width: 3.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: MyColors.gray,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        focusColor: const Color.fromARGB(255, 24, 237, 105),
      ),
    ),
  );
}

mySmallDropDown({
  required DropdownEditingController<String> controller,
  required List<String> options,
  required String label,
  required String? Function(String?) validate,
}) {
  return Container(
    margin: const EdgeInsets.only(
      left: 10,
      right: 10,
    ),
    child: TextDropdownFormField(
      validator: validate,
      controller: controller,
      dropdownHeight: 100,
      options: options,
      decoration: InputDecoration(
        hintText: label,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50))),
        suffixIcon: const Icon(
          Icons.arrow_drop_down,
        ),
      ),
    ),
  );
}
