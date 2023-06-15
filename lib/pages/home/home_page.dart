import 'package:flutter/material.dart';
import 'package:to_do_list/pages/home/widgets/task_cell_widget.dart';
import 'package:to_do_list/utils/utils.dart';
import 'package:to_do_list/navigation/navigation.dart';
import 'package:to_do_list/pages/home/widgets/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> toDoList = [
    Task('something 1', Priority.none, false),
    Task(
        'another task loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong',
        Priority.low,
        true,
        DateTime.now()),
    Task('something 2', Priority.none, false),
    Task('something 3', Priority.none, false),
    Task('something 4', Priority.none, false),
    Task('something 5', Priority.none, false),
    Task('something 6', Priority.none, false),
    Task('something 7', Priority.high, false),
    Task('something 8', Priority.none, false),
    Task('something 9', Priority.none, false),
    Task('something 10', Priority.none, false),
    Task('something 11', Priority.none, false),
    Task('something 12', Priority.none, false),
    Task('something 13', Priority.none, false),
    Task('something 14', Priority.none, false),
    Task('something 15', Priority.none, false),
    Task('something 16', Priority.none, false),
    Task('something 17', Priority.none, false),
  ];

  int completed = 0;
  bool _showCompleted = true;

  @override
  void initState() {
    _numOfCompleted();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _onTaskOpen(int index, Task task) async {
    final result = await NavigationManager.instance.openTask(task);
    if (result != null) {
      setState(() {
        if (result.text != null) {
          toDoList[index] = result;
        } else {
          toDoList.removeAt(index);
        }
      });
    }
  }

  Future<void> _onTaskCreate() async{
    final result = await NavigationManager.instance.openTask(Task());
    if (result != null) {
      setState(() {
        if (result.text != null) {
          toDoList.add(result);
        }
      });
    }
  }

  void _numOfCompleted() {
    int num = 0;
    for (int i = 0; i < toDoList.length; i++) {
      if (toDoList[i].done) {
        num++;
      }
    }
    setState(() {
      completed = num;
    });
  }

  Future<void> _handleDismiss(DismissDirection direction, int index) async {
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
              _numOfCompleted();
            }),
      );
      ScaffoldMessenger.of(context).showSnackBar(s);
    }
  }

  Future<bool> _promptUser(direction) async {
    String action;
    if (direction == DismissDirection.endToStart) {
      action = "delete";
    } else {
      action = "Complete";
      return true;
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
          CustomAppBar(
            showCompleted: _showCompleted,
            completed: completed,
            onEyePressed: (){
              setState(() {
                _showCompleted = !_showCompleted;
              });
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListView.builder(
                      controller: ScrollController(),
                      padding: const EdgeInsets.only(top: 0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Visibility(
                          visible: !toDoList[index].done ||
                              (_showCompleted && toDoList[index].done),
                          child: TaskCellWidget(
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
                              _numOfCompleted();
                            },
                            confirmDismiss: (direction) async {
                              bool dismissed = await _promptUser(direction);
                              if (dismissed &&
                                  direction == DismissDirection.startToEnd) {
                                setState(() {
                                  toDoList[index].done = !toDoList[index].done;
                                });
                                _numOfCompleted();
                                return false;
                              }
                              return dismissed;
                            },
                            onDismissed: (direction) {
                              _handleDismiss(direction, index);
                              _numOfCompleted();
                            },
                            onInfoPressed: () =>
                                _onTaskOpen(index, toDoList[index]),
                          ),
                        );
                      },
                      itemCount: toDoList.length,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: toDoList.isNotEmpty
                              ? const Radius.circular(0.0)
                              : const Radius.circular(8.0),
                          bottom: const Radius.circular(8.0),
                        ),
                        color: const Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _onTaskCreate();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onTaskCreate();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
