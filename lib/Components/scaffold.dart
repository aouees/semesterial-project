import 'package:flutter/material.dart';

import '../Constants/colors.dart';

Widget myScaffold({
  required BuildContext context,
  Widget? header,
  required Widget body,
  Widget? footer,
}) {
  List<Widget> widgets = [
    Expanded(child: body),
  ];
  if (header != null) {
    widgets.insert(0, header);
  }
  if (footer != null) {
    widgets.add(footer);
  }
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
      MyColors.yalow,
      MyColors.blue,
    ])),
    child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: widgets,
          ),
        )),
  );
}

Widget myAppBar(
    {required String title,
    required BuildContext context,
    IconButton? rightButton,
    IconButton? leftButton}) {
  var widgets = [
    Expanded(
      flex: 4,
      child: DefaultTextStyle(
        style: const TextStyle(
            color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ];
  if (rightButton != null) {
    widgets.add(Expanded(flex: 1, child: rightButton));
  } else {
    widgets.add(const Expanded(
      flex: 1,
      child: Icon(null),
    ));
  }
  if (leftButton != null) {
    widgets.insert(0, Expanded(flex: 1, child: leftButton));
  } else {
    widgets.insert(
        0,
        const Expanded(
          flex: 1,
          child: Icon(null),
        ));
  }
  return Container(
    decoration: BoxDecoration(boxShadow: const [
      BoxShadow(
        color: Colors.black54,
        blurRadius: 15,
      ),
    ], borderRadius: BorderRadius.circular(50), color: Colors.white),
    margin: const EdgeInsets.all(15),
    height: MediaQuery.of(context).orientation == Orientation.landscape
        ? 0.09 * MediaQuery.of(context).size.height
        : 0.07 * MediaQuery.of(context).size.height,
    child: Row(
      children: widgets,
    ),
  );
}
