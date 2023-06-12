enum Priority{
  none, low, high
}

class Task{
  String? text;
  Priority priority = Priority.none;
  DateTime? date;
  bool done = false;
}