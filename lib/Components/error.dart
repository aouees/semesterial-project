import 'package:flutter/material.dart';

myError({required String msg, required VoidCallback onPressed}) {
  return Center(
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      elevation: 25,
      shadowColor: Colors.red,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.red, width: 2)),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 25, 10, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              msg,
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
            const SizedBox(height: 15),
            MaterialButton(
              color: Colors.redAccent,
              shape: const StadiumBorder(),
              onPressed: onPressed,
              child: const Text('حاول مجدداً',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  )),
            )
          ],
        ),
      )),
    ),
  );
}
