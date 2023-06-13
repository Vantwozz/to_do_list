import 'package:flutter/material.dart';
import 'package:to_do_list/utils/utils.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  TaskPage(this.task, this.isNewTask, {Key? key}) : super(key: key);
  bool isNewTask = false;
  Task task;

  @override
  State<TaskPage> createState() => _TaskPageState(task, isNewTask);//вынести
}

class _TaskPageState extends State<TaskPage> {
  _TaskPageState(this.task, this.isNewTask) {
    if (task.date != null) {
      _switch = true;
      date = task.date;
    }
    switch (task.priority) {
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
    defaultTaskName = task.text;
  }

  Task task;
  bool isNewTask;

  String? defaultTaskName;
  var priorityList = [
    'None',
    'Low',
    '!!High',
  ];
  bool _switch = false;
  DateTime? date;
  String? dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf7f6f2),
        leading: CloseButton(
            onPressed: () {
              return;
            },
            color: Colors.black),
        actions: [
          TextButton(
              onPressed: () {
                return;
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Color(0xFF007AFF), fontSize: 14),
              )),
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
                    controller: TextEditingController(text: defaultTaskName),
                  ),
                )),
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
                      })
                ],
              ),
            ),
            const Divider(color: Color.fromRGBO(0, 0, 0, 0.2)),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: TextButton.icon(
                  onPressed: isNewTask
                      ? null
                      : () {
                          return;
                        },
                  icon: Icon(Icons.delete,
                      color: isNewTask
                          ? const Color.fromRGBO(0, 0, 0, 0.15)
                          : const Color(0xFFFF3B30)),
                  label: Text('Delete',
                      style: TextStyle(
                          fontSize: 16,
                          color: isNewTask
                              ? const Color.fromRGBO(0, 0, 0, 0.15)
                              : const Color(0xFFFF3B30)))),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xFFf7f6f2),
    );
  }
}
