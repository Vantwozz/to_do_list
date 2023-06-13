import 'package:flutter/material.dart';
import 'package:to_do_list/pages/home/homepage.dart';
import 'package:to_do_list/pages/tasks/taskpage.dart';
import 'package:to_do_list/utils/uils.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),//TaskPage(Task('To do smthing',Priority.high, true ,DateTime(2023)), false),
    )
  );
}