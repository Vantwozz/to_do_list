import 'package:logger/logger.dart';
import 'package:quiver/core.dart';

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

class MyLogger {
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
      done: json['done'].runtimeType == bool
          ? json['done']
          : (json['done'] == 1 ? true : false),
      color: json.containsKey('color') ? json['color'] : null,
      createdAt: json['created_at'],
      changedAt: json['changed_at'],
      lastUpdatedBy: json['last_updated_by'],
    );
  }

  @override
  bool operator ==(other) {
    return other is AdvancedTask &&
        (id == other.id &&
            text == other.text &&
            importance == other.importance &&
            deadline == other.deadline &&
            done == other.done &&
            color == other.color &&
            createdAt == other.createdAt &&
            lastUpdatedBy == other.lastUpdatedBy);
  }

  @override
  int get hashCode => hash2(
        hash4(
          id.hashCode,
          text.hashCode,
          importance.hashCode,
          deadline.hashCode,
        ),
        hash4(
          done.hashCode,
          color.hashCode,
          createdAt.hashCode,
          lastUpdatedBy.hashCode,
        ),
      );
}
