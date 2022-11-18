import 'package:flutter/material.dart';
import 'package:semesterial_project_admin/Components/scaffold.dart';

class WaitScreen extends StatelessWidget {
  const WaitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return myScaffold(
        context: context,
        body: Center(
          child: Image.asset(
            "assets/waiting.gif",
          ),
        ));
  }
}
