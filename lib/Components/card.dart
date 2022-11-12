import 'package:flutter/material.dart';

import '../Constants/colors.dart';

myCard(
    {List<IconButton>? actions,
    required List<Widget> values,
    void Function()? onClick}) {
  var widgets = [
    Expanded(
        flex: 3,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, children: values))
  ];
  if (actions != null) {
    widgets.add(Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions,
      ),
    ));
  }
  return Directionality(
    textDirection: TextDirection.rtl,
    child: InkWell(
      onTap: onClick,
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widgets,
        ),
      ),
    ),
  );
}

myValues(String k, String v) {
  return Padding(
    padding: const EdgeInsets.only(right: 15.0, top: 2.0, bottom: 2.0),
    child: Row(
      children: [
        Text(
          '$k : ',
          style: const TextStyle(
              fontSize: 19, color: MyColors.blue, fontWeight: FontWeight.bold),
        ),
        Text(
          v,
          style: const TextStyle(fontSize: 19),
        ),
      ],
    ),
  );
}
