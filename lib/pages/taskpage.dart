import 'package:flutter/material.dart';
import 'package:to_do_list/include/task.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  TaskPage(this.task, this.isNewTask, {Key? key}) : super(key: key);
  bool isNewTask = false;
  Task task;

  @override
  State<TaskPage> createState() => _TaskPageState(task, isNewTask);
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
                style: TextStyle(color: Colors.blue, fontSize: 14),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Task to do',
                    filled: true,
                    fillColor: Colors.white),
                autofocus: false,
                maxLines: null,
                keyboardType: TextInputType.text,
                minLines: 4,
                controller: TextEditingController(text: defaultTaskName),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('Priority', style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 16),
              child: DropdownButton<String>(
                items: priorityList.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                      items,
                      style: TextStyle(
                          color: items == '!!High' ? Colors.red : Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                isExpanded: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 16),
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
                          style:
                              const TextStyle(fontSize: 12, color: Colors.blue))
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
            const Divider(color: Colors.black),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: TextButton.icon(
                  onPressed: isNewTask
                      ? null
                      : () {
                          return;
                        },
                  icon: Icon(Icons.delete, color: isNewTask ? Colors.grey[400] : Colors.red),
                  label: Text('Delete',
                      style: TextStyle(fontSize: 16, color: isNewTask ? Colors.grey[400] : Colors.red))),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xFFf7f6f2),
    );
  }
}
