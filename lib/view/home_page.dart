import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/domain/data_manager.dart';
import 'package:to_do_list/domain/utils.dart';
import 'package:to_do_list/navigation/navigation.dart';
import 'package:to_do_list/view/widgets/app_bar.dart';
import 'package:to_do_list/view/widgets/task_cell_widget.dart';

import '../locator.dart';
import 'home_page_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    initList();
    _numOfCompleted();
    MyLogger.l.d('Logger is working!');
    // TODO: implement initState
    super.initState();
  }

  Task _changeCompleted(Task task) {
    task.done = !task.done;
    return task;
  }

  void initList() async {
    await synchronizeLists();
    await _getList();
    _numOfCompleted();
  }

  Future<void> synchronizeLists() async {
    bool connected = await locator.get<DataManager>().checkConnection();
    if (!connected) {
      _showSnackBar();
      return;
    } else {
      if (await locator.get<DataManager>().equalLists()) {
        return;
      } else {
        await _showMyDialog();
      }
    }
  }

  void _showSnackBar() {
    const s = SnackBar(
      content: Text(
          "Can't connect to backend. Everything is saving to local storage."),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(s);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
                if (!(await locator.get<DataManager>().downloadToLocal())) {
                  _showSnackBar();
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text('Download list from local storage'),
              onPressed: () async {
                if (!(await locator.get<DataManager>().uploadFromLocal())) {
                  _showSnackBar();
                  await locator.get<DataManager>().checkConnection();
                } else {
                  await locator.get<DataManager>().downloadToLocal();
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getList() async {
    List<AdvancedTask> advTasks = await locator.get<DataManager>().getList();
    for (int i = 0; i < advTasks.length; i++) {
      listProvider.add(
        StateProvider(
          (ref) => Task(
            advTasks[i].id,
            advTasks[i].text,
            getPriority(advTasks[i].importance),
            advTasks[i].done,
            advTasks[i].deadline != null
                ? DateTime.fromMillisecondsSinceEpoch(advTasks[i].deadline!)
                : null,
          ),
        ),
      );
      ref.read(length.notifier).update((state) => listProvider.length);
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
    while (i < listProvider.length) {
      if (!ref.read(listProvider[i]).done) {
        break;
      }
      i++;
    }
    return (i == index);
  }

  bool _allCompleted() {
    return (ref.read(numOfCompleted) == listProvider.length);
  }

  Future<void> _onTaskOpen(int index, Task task) async {
    MyLogger.l.d('Info button pressed. Opening task page');
    final result = await locator.get<NavigationManager>().openTask(task);
    MyLogger.l.d('Task page closed');
    if (result != null) {
      if (result.text != null) {
        ref.read(listProvider[index].notifier).update((state) => result);
        if (!(await locator
            .get<DataManager>()
            .updateTask(ref.read(listProvider[index])))) {
          await locator.get<DataManager>().checkConnection();
          _showSnackBar();
        }
      } else {
        String id = ref.read(listProvider[index]).id;
        listProvider.removeAt(index);
        ref.read(length.notifier).update((state) => listProvider.length);
        _numOfCompleted();
        if (!(await locator.get<DataManager>().deleteTaskById(id))) {
          await locator.get<DataManager>().checkConnection();
          _showSnackBar();
        }
      }
    }
  }

  Future<void> _onTaskCreate() async {
    MyLogger.l.d('Creation button pressed. Opening task page');
    final result = await locator
        .get<NavigationManager>()
        .openTask(Task(locator.get<DataManager>().generateUuid()));
    MyLogger.l.d('Task page closed');
    if (result != null) {
      if (result.text != null) {
        listProvider.add(StateProvider((ref) => result));
        ref.read(length.notifier).update((state) => listProvider.length);
        if (!(await locator.get<DataManager>().createTask(result))) {
          await locator.get<DataManager>().checkConnection();
          _showSnackBar();
        }
      }
    }
  }

  Future<void> _onDismissed(int index) async {
    String id = ref.read(listProvider[index]).id;
    MyLogger.l.d('Dismiss confirmed');
    listProvider.removeAt(index);
    ref.read(length.notifier).update((state) => listProvider.length);
    _numOfCompleted();
    if (!(await locator.get<DataManager>().deleteTaskById(id))) {
      await locator.get<DataManager>().checkConnection();
      _showSnackBar();
    }
  }

  Future<bool> _confirmDismiss(DismissDirection direction, int index) async {
    bool dismissed = await _promptUser(direction);
    if (dismissed && direction == DismissDirection.startToEnd) {
      Task newTask = _changeCompleted(ref.read(listProvider[index]));
      ref.read(listProvider[index].notifier).update((state) => newTask);
      if (!(await locator
          .get<DataManager>()
          .updateTask(ref.read(listProvider[index])))) {
        await locator.get<DataManager>().checkConnection();
        _showSnackBar();
      }
      _numOfCompleted();
      MyLogger.l.d('Task ${ref.read(listProvider[index]).text} done/restored');
      return false;
    }
    return dismissed;
  }

  Future<void> _checkBoxChanged(int index) async {
    MyLogger.l.d('Checkbox changed. Task done/restored');
    Task newTask = _changeCompleted(ref.read(listProvider[index]));
    ref.read(listProvider[index].notifier).update((state) => newTask);
    if (!(await locator
        .get<DataManager>()
        .updateTask(ref.read(listProvider[index])))) {
      await locator.get<DataManager>().checkConnection();
      _showSnackBar();
    }
    _numOfCompleted();
  }

  void _numOfCompleted() {
    int num = 0;
    for (int i = 0; i < listProvider.length; i++) {
      if (ref.read(listProvider[i]).done) {
        num++;
      }
    }
    ref.read(numOfCompleted.notifier).update((state) => num);
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
                  child: const Text('Cancel'),
                  onPressed: () {
                    MyLogger.l.d('Deletion cancelled');
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    MyLogger.l.d('Deletion confirmed');
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
    var itemCount = ref.watch(length);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: CustomScrollView(
        controller: ScrollController(),
        slivers: <Widget>[
          CustomAppBar(
            showCompleted: ref.watch(showCompleted),
            completed: ref.watch(numOfCompleted),
            onEyePressed: () {
              MyLogger.l.d('Eye button pressed. Shown/hidden completed tasks');
              ref
                  .read(showCompleted.notifier)
                  .update((state) => !ref.read(showCompleted));
              setState(() {});
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
                      itemCount: itemCount,
                      itemBuilder: (BuildContext context, int index) {
                        bool taskIsDone = ref.watch(listProvider[index]).done;
                        return Visibility(
                          visible: !taskIsDone ||
                              (ref.watch(showCompleted) && taskIsDone),
                          child: TaskCellWidget(
                            key: UniqueKey(),
                            task: index,
                            borderRadius: index == 0 ||
                                    (_isFirstOfUncompleted(index) &&
                                        !ref.watch(showCompleted))
                                ? const BorderRadius.vertical(
                                    bottom: Radius.circular(0.0),
                                    top: Radius.circular(8.0))
                                : null,
                            checkBoxChanged: (value) async {
                              _checkBoxChanged(index);
                            },
                            confirmDismiss: (direction) async {
                              return _confirmDismiss(direction, index);
                            },
                            onDismissed: (direction) async {
                              await _onDismissed(index);
                            },
                            onInfoPressed: () => _onTaskOpen(
                                index, ref.read(listProvider[index])),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: listProvider.isEmpty ||
                                  (_allCompleted() && !ref.watch(showCompleted))
                              ? const Radius.circular(8.0)
                              : const Radius.circular(0.0),
                          bottom: const Radius.circular(8.0),
                        ),
                        color: const Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: TextButton(
                        onPressed: () {
                          MyLogger.l.d('Pressed \'add\' button in list');
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
          MyLogger.l.d('Pressed floating button');
          _onTaskCreate();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
