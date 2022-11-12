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
