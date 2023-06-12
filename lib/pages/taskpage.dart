import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  var priority = [
    'None',
    'Low',
    'High',
  ];

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
                style: TextStyle(color: Colors.blue),
              )),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Task to do',
                  ),
                  autofocus: false,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  minLines: 4,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text('Priority', style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: DropdownButton<String>(
                  items: priority.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items, style: TextStyle(color: items=='High'? Colors.red : Colors.black ),),
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
            ],
          ),
      ),
      backgroundColor: const Color(0xFFf7f6f2),
    );
  }
}
