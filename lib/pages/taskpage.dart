import 'package:flutter/material.dart';
import 'package:to_do_list/include/task.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  var priority = [
    'None',
    'Low',
    '!!High',
  ];
  bool _switch = false;
  DateTime? date;

  String dropdownValue = 'None';

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
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text('Priority', style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 16),
              child: DropdownButton<String>(
                items: priority.map((String items) {
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
                              //get today's date
                              firstDate: DateTime.now(),
                              //DateTime.now() - not to allow to choose before today.
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
                  onPressed: () {
                    return;
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(fontSize: 16, color: Colors.red))
              ),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xFFf7f6f2),
    );
  }
}
