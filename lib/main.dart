import 'package:flutter/material.dart';
import 'package:to_do_list/pages/homepage.dart';
import 'package:to_do_list/pages/taskpage.dart';

void main() {
  runApp(
    MaterialApp(
      restorationScopeId: 'app',
      home: TaskPage(),
    )
  );
}