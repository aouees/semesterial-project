
import 'package:flutter/material.dart';

mySnackBar(String content, BuildContext context, Color background, Color textColor) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
      style: TextStyle(color: textColor),
    ),
    backgroundColor: background,
    duration: const Duration(milliseconds: 2000),
  ));
}
