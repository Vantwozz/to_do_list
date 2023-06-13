enum Priority{
  none, low, high
}

class Task{
  String? text;
  Priority priority;
  DateTime? date;
  bool done;

  Task([this.text, this.priority = Priority.none, this.done = false, this.date]);
}