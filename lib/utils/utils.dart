import 'dart:ffi';

import 'package:logger/logger.dart';

enum Priority {
  none,
  low,
  high,
}

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
  int? deadline;
  bool done;
  String? color;
  int createdAt;
  int changedAt;
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

  factory AdvancedTask.fromJson(dynamic json) {
    return AdvancedTask(
      id: json['id'],
      text: json['text'],
      importance: json['importance'],
      deadline: json.containsKey('deadline') ? json['deadline'] : null,
      done: json['done'],
      color: json.containsKey('color') ? json['color'] : null,
      createdAt: json['created_at'],
      changedAt: json['changed_at'],
      lastUpdatedBy: json['last_updated_by'],
    );
  }
}
