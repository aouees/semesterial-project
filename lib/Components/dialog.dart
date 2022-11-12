import 'package:flutter/material.dart';

import '../Constants/colors.dart';

void myDialog({required BuildContext context, required Widget body}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: MyColors.blue, width: 3),
            borderRadius: BorderRadius.circular(30)),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: body,
          ),
        ),
      );
    },
  );
}
