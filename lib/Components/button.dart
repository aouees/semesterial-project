import 'package:flutter/material.dart';

import '../Constants/colors.dart';

myGradiantButton(
    {required BuildContext context,
    required void Function() onPressed,
    required String title,
    required IconData icon}) {
  return Container(
    decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          MyColors.yalow,
          MyColors.blue,
        ]),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 15,
          ),
        ],
        color: Colors.white),
    height: 0.07 * MediaQuery.of(context).size.height,
    child: MaterialButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(title,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 20,
                )),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            flex: 1,
            child: Align(alignment: Alignment.centerLeft, child: Icon(icon)),
          )
        ],
      ),
    ),
  );
}

myNormalButton(
    {required void Function() onPressed,
    required String title,
    required IconData icon}) {
  return Container(
    margin: const EdgeInsets.all(15),
    child: MaterialButton(
      color: MyColors.blue,
      shape: const StadiumBorder(),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 20,
              )),
          Icon(
            icon,
          )
        ],
      ),
    ),
  );
}

Widget clickableGridTile(String title, String pathIcon, void Function()? onPressed) {
  List<Widget> widgets = [];
  if (onPressed == null) {
    widgets.add(Container(
        color: Colors.grey.withOpacity(0.5),
        child: const Center(
            child: Text(
          'Coming soon',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ))));
  }
  return Card(
    elevation: 10,
    shape: RoundedRectangleBorder(
        side: const BorderSide(color: MyColors.blue, width: 4),
        borderRadius: BorderRadius.circular(30)),
    child: InkWell(
      borderRadius: BorderRadius.circular(30),
      splashColor: MyColors.blue,
      onTap: onPressed,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 60,
                  child: Image.asset(pathIcon),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          onPressed == null
              ? Container(
                  color: MyColors.blue.withOpacity(0.4),
                  child: const Center(
                      child: Text(
                    'Coming soon',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )))
              : Container()
        ],
      ),
    ),
  );
}