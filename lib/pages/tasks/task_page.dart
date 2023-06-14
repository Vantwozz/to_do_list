import 'package:flutter/material.dart';
import 'package:to_do_list/utils/utils.dart';
import 'package:to_do_list/navigation/navigation.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({required this.task, Key? key}) : super(key: key);
  final Task task;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Task? task;
  bool? isNewTask;
  String? taskName;
  var priorityList = [
    'None',
    'Low',
    '!!High',
  ];
  bool _switch = false;
  DateTime? date;
  String? dropdownValue;
  TextEditingController? textController;

  @override
  void initState() {
    task = widget.task;
    isNewTask = task!.text == null;
    if (task!.date != null) {
      _switch = true;
      date = task!.date;
    }
    switch (task!.priority) {
      case Priority.none:
        dropdownValue = priorityList[0];
        break;
      case Priority.low:
        dropdownValue = priorityList[1];
        break;
      case Priority.high:
        dropdownValue = priorityList[2];
        break;
    }
    taskName = task!.text;
    textController = TextEditingController(text: taskName);
    // TODO: implement initState
    super.initState();
  }

  Priority _dropdownValueToPriority() {
    Priority? pr;
    switch (dropdownValue) {
      case 'None':
        pr = Priority.none;
        break;
      case 'Low':
        pr = Priority.low;
        break;
      case '!!High':
        pr = Priority.high;
        break;
    }
    return pr!;
  }

  @override
  void dispose() {
    textController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _onGoBack() {
    NavigationManager.instance.pop(task);
  }

  void _onDelete() async {
    if(await _promptUser()) {
      NavigationManager.instance.pop(
        Task(),
      );
    }
  }

  void _onSave() {
    if (textController!.text != '') {
      NavigationManager.instance.pop(
        Task(
            textController!.text, _dropdownValueToPriority(), task!.done, date),
      );
    } else {
      _onDelete();
    }
  }

  Future<bool> _promptUser() async {
    return await showDialog<bool>(
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(isNewTask! ? 'You can\'t make empty task! Are you want to go back?' : 'Are you sure you want to Delete this task?'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
          context: context,
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf7f6f2),
        leading: CloseButton(
            onPressed: () {
              _onGoBack();
            },
            color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              _onSave();
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFF007AFF), fontSize: 14),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Material(
                borderRadius: BorderRadius.circular(8.0),
                elevation: 2,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none),
                      hintText: 'Task to do',
                      filled: true,
                      fillColor: Colors.white),
                  autofocus: false,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  minLines: 4,
                  controller: textController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Priority', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    items: priorityList.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(
                            color: items == '!!High'
                                ? const Color(0xFFFF3B30)
                                : const Color.fromRGBO(0, 0, 0, 0.3),
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    value: dropdownValue,
                    icon: const Visibility(
                        visible: false, child: Icon(Icons.accessible)),
                    isExpanded: true,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Make by date',
                          style: TextStyle(fontSize: 16)),
                      Text(
                          date != null
                              ? DateFormat('yyyy-MM-dd').format(date!)
                              : '',
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF007AFF)))
                    ],
                  ),
                  const Spacer(),
                  Switch(
                    value: _switch,
                    onChanged: (bool value) async {
                      setState(() {
                        _switch = value;
                      });
                      if (value) {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          setState(() {
                            date = pickedDate;
                          });
                        } else {
                          setState(() {
                            _switch = false;
                          });
                        }
                      } else {
                        setState(() {
                          date = null;
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            const Divider(color: Color.fromRGBO(0, 0, 0, 0.2)),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: TextButton.icon(
                onPressed: isNewTask!
                    ? null
                    : () {
                        _onDelete();
                      },
                icon: Icon(Icons.delete,
                    color: isNewTask!
                        ? const Color.fromRGBO(0, 0, 0, 0.15)
                        : const Color(0xFFFF3B30)),
                label: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 16,
                    color: isNewTask!
                        ? const Color.fromRGBO(0, 0, 0, 0.15)
                        : const Color(0xFFFF3B30),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xFFf7f6f2),
    );
  }
}