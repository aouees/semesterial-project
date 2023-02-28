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

onError() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
        child: SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/error.png'),
              const SizedBox(
                height: 10,
              ),
              Text(
                details.exception.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                child: const Text(
                  'نعتذر عن هذا الخطأ : قم بارسال لقطة شاشة لهذه الواجهة لفريق التطوير ',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),
              )
            ],
          ),
        ),
      ),
    ));
  };
}
