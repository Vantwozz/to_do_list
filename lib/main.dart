import 'package:flutter/material.dart';
import 'package:to_do_list/pages/homepage.dart';
import 'package:to_do_list/pages/taskpage.dart';
import 'package:to_do_list/include/task.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),//TaskPage(Task('To do smthing',Priority.high, true ,DateTime(2023)), false),
    )
  );
}