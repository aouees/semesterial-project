import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semesterial_project_admin/Constants/colors.dart';

mySnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 1),
  ));
}
