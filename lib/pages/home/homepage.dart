import 'package:flutter/material.dart';
import 'package:to_do_list/pages/home/widgets/taskcellwidget.dart';
import 'package:to_do_list/pages/tasks/taskpage.dart';
import 'package:to_do_list/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> toDoList = [
    Task('something', Priority.none, false),
    Task(
        'another task loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong',
        Priority.low,
        true,
        DateTime.now()),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.high, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
    Task('something', Priority.none, false),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  handleDismiss(DismissDirection direction, int index) async {
    final swiped = toDoList[index];
    String action;
    if (direction == DismissDirection.endToStart) {
      action = "Deleted";
      setState(() {
        toDoList.removeAt(index);
      });
      final s = SnackBar(
        content: Text("$action. Do you want to undo?"),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: "Undo",
            textColor: Colors.yellow,
            onPressed: () {
              setState(() => toDoList.insert(index, swiped));
            }),
      );
      ScaffoldMessenger.of(context).showSnackBar(s);
    }
  }

  Future<bool> promptUser(direction) async {
    String action;
    if (direction == DismissDirection.endToStart) {
      action = "Delete";
    } else {
      action = "Complete";
    }
    return await showDialog<bool>(
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Are you sure you want to $action?'),
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
      backgroundColor: const Color(0xFFF7F6F2),
      body: CustomScrollView(
        controller: ScrollController(),
        slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            backgroundColor: Color(0xFFF7F6F2),
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'SliverAppBar',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 3),
              child: Material(
                borderRadius: BorderRadius.circular(8.0),
                elevation: 2,
                child: Column(
                  children: [
                    ListView.builder(
                      controller: ScrollController(),
                      padding: const EdgeInsets.only(top: 0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskCellWidget(
                          key: UniqueKey(),
                          task: toDoList[index],
                          borderRadius: index == 0
                              ? const BorderRadius.vertical(
                                  bottom: Radius.circular(0.0),
                                  top: Radius.circular(8.0))
                              : null,
                          checkBoxChanged: (value) {
                            setState(() {
                              toDoList[index].done = !toDoList[index].done;
                            });
                          },
                          confirmDismiss: (direction) async {
                            bool dismissed = await promptUser(direction);
                            if (dismissed &&
                                direction == DismissDirection.startToEnd) {
                              setState(() {
                                toDoList[index].done = !toDoList[index].done;
                              });
                              return false;
                            }
                            return dismissed;
                          },
                          onDismissed: (direction) {
                            handleDismiss(direction, index);
                          },
                        );
                      },
                      itemCount: toDoList.length,
                    ),
                    Material(
                      borderRadius: BorderRadius.vertical(
                        top: toDoList.isNotEmpty
                            ? const Radius.circular(0.0)
                            : const Radius.circular(8.0),
                        bottom: const Radius.circular(8.0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          return;
                        },
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.white),
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
