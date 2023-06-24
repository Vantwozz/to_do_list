import 'dart:core';
import 'package:flutter/material.dart';
import 'package:to_do_list/pages/home/widgets/task_cell_widget.dart';
import 'package:to_do_list/utils/utils.dart';
import 'package:to_do_list/navigation/navigation.dart';
import 'package:to_do_list/pages/home/widgets/app_bar.dart';
import 'package:to_do_list/managers/data_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> toDoList = [];

  int completed = 0;
  bool _showCompleted = true;

  @override
  void initState() {
    initList();
    _numOfCompleted();
    logger.l.d('Logger is working!');
    // TODO: implement initState
    super.initState();
  }

  void initList() async {
    await synchronizeLists();
    await getList();
    _numOfCompleted();
  }

  Future<void> synchronizeLists() async {
    bool connected = await DataManager.manager.checkConnection();
    if (!connected) {
      const s = SnackBar(
        content: Text("Can't connect to backend"),
        duration: Duration(seconds: 3),
      );
      return;
    } else {
      if (await DataManager.manager.equalLists()) {
        print("equal");
        return;
      } else {
        await _showMyDialog();
      }
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Synchronize lists!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Lists on backend and in local storage are not synchronized'),
                Text('How do you want to fix it?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Download list from backend'),
              onPressed: () async {
                await DataManager.manager.downloadToLocal();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Download list from local storage'),
              onPressed: () async {
                await DataManager.manager.uploadFromLocal();
                await DataManager.manager.downloadToLocal();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getList() async {
    List<AdvancedTask> advTasks = await DataManager.manager.getList();
    for (int i = 0; i < advTasks.length; i++) {
      toDoList.add(
        Task(
          advTasks[i].id,
          advTasks[i].text,
          getPriority(advTasks[i].importance),
          advTasks[i].done,
          advTasks[i].deadline != null
              ? DateTime.fromMillisecondsSinceEpoch(advTasks[i].deadline!)
              : null,
        ),
      );
    }
  }

  Priority getPriority(String importance) {
    Priority ans;
    switch (importance) {
      case 'basic':
        ans = Priority.none;
        break;
      case 'low':
        ans = Priority.low;
        break;
      case 'important':
        ans = Priority.high;
        break;
      default:
        ans = Priority.none;
    }
    return ans;
  }

  bool _isFirstOfUncompleted(int index) {
    int i = 0;
    while (i < toDoList.length) {
      if (!toDoList[i].done) {
        break;
      }
      i++;
    }
    return (i == index);
  }

  bool _allCompleted() {
    return (completed == toDoList.length);
  }

  Future<void> _onTaskOpen(int index, Task task) async {
    logger.l.d('Info button pressed. Opening task page');
    final result = await NavigationManager.instance.openTask(task);
    logger.l.d('Task page closed');
    if (result != null) {
      if (result.text != null) {
        setState(() {
          toDoList[index] = result;
        });
        await DataManager.manager.updateTask(result);
      } else {
        String id = toDoList[index].id;
        setState(() {
          toDoList.removeAt(index);
        });
        await DataManager.manager.deleteTaskById(id);
      }
    }
  }

  Future<void> _onTaskCreate() async {
    logger.l.d('Creation button pressed. Opening task page');
    final result = await NavigationManager.instance
        .openTask(Task(DataManager.manager.generateUuid()));
    logger.l.d('Task page closed');
    if (result != null) {
      setState(() {
        if (result.text != null) {
          toDoList.add(result);
          DataManager.manager.createTask(result);
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

  /*Future<void> _handleDismiss(DismissDirection direction, int index) async {
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
            onPressed: () async {
              setState(
                () => toDoList.insert(index, swiped),
              );
              _numOfCompleted();
              logger.l.d('Element has been restored');
              await DataManager.manager.createTask(swiped);
            }),
      );
      ScaffoldMessenger.of(context).showSnackBar(s);
    }
  }*/

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
                  child: const Text('Cancel'),
                  onPressed: () {
                    logger.l.d('Deletion cancelled');
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    logger.l.d('Deletion confirmed');
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
            onEyePressed: () {
              setState(() {
                logger.l.d('Eye button pressed. Shown/hidden completed tasks');
                _showCompleted = !_showCompleted;
              });
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 3, 8, 18),
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
                            borderRadius: index == 0 ||
                                    (_isFirstOfUncompleted(index) &&
                                        !_showCompleted)
                                ? const BorderRadius.vertical(
                                    bottom: Radius.circular(0.0),
                                    top: Radius.circular(8.0))
                                : null,
                            checkBoxChanged: (value) async {
                              logger.l
                                  .d('Checkbox changed. Task done/restored');
                              setState(() {
                                toDoList[index].done = !toDoList[index].done;
                              });
                              await DataManager.manager
                                  .updateTask(toDoList[index]);
                              _numOfCompleted();
                            },
                            confirmDismiss: (direction) async {
                              bool dismissed = await _promptUser(direction);
                              if (dismissed &&
                                  direction == DismissDirection.startToEnd) {
                                setState(() {
                                  toDoList[index].done = !toDoList[index].done;
                                });
                                await DataManager.manager
                                    .updateTask(toDoList[index]);
                                _numOfCompleted();
                                logger.l.d(
                                    'Task ${toDoList[index].text} done/restored');
                                return false;
                              }
                              return dismissed;
                            },
                            onDismissed: (direction) async {
                              String id = toDoList[index].id;
                              logger.l.d('Dismiss confirmed');
                              setState(() {
                                toDoList.removeAt(index);
                                _numOfCompleted();
                              });
                              await DataManager.manager.deleteTaskById(id);
                              //await _handleDismiss(direction, index);
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
                          top: toDoList.isEmpty ||
                                  (_allCompleted() && !_showCompleted)
                              ? const Radius.circular(8.0)
                              : const Radius.circular(0.0),
                          bottom: const Radius.circular(8.0),
                        ),
                        color: const Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: TextButton(
                        onPressed: () {
                          logger.l.d('Pressed \'add\' button in list');
                          _onTaskCreate();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40,
                            ),
                            Text(
                              'Add',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logger.l.d('Pressed floating button');
          _onTaskCreate();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
