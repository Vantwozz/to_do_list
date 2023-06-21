import 'dart:ffi';

import 'package:logger/logger.dart';

enum Priority { none, low, high }

class Task {
  String id;
  String? text;
  Priority priority;
  DateTime? date;
  bool done;

  Task(this.id,
      [this.text, this.priority = Priority.none, this.done = false, this.date]);
}

class logger {
  static var l = Logger();
}

class AdvancedTask {
  String id;
  String text;
  String importance;
  Long? deadline;
  Bool done;
  String? color;
  Long createdAt;
  Long changedAt;
  String lastUpdatedBy;

  AdvancedTask({
    required this.id,
    required this.text,
    required this.importance,
    this.deadline,
    required this.done,
    this.color,
    required this.createdAt,
    required this.changedAt,
    required this.lastUpdatedBy,
  });
}
