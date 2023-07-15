import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/domain/utils.dart';
import 'package:to_do_list/navigation/navigation.dart';
import 'package:to_do_list/view/task_page_provider.dart';

import '../locator.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({required this.task, Key? key}) : super(key: key);
  final Task task;

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  Task? task;
  bool? isNewTask;
  String? taskName;
  var priorityList = [
    'None',
    'Low',
    '!!High',
  ];

  TextEditingController? textController;

  @override
  void initState() {
    MyLogger.l.d('Task page opened');
    locator.get<FirebaseAnalytics>().logEvent(
          name: 'Task page opened',
        );
    task = widget.task;
    isNewTask = task!.text == null;
    _initTask();
    taskName = task!.text;
    textController = TextEditingController(text: taskName);
    // TODO: implement initState
    super.initState();
  }

  Future<void> _initTask() async {
    await Future.delayed(const Duration(microseconds: 1));
    if (task!.date != null) {
      ref.read(dateProvider.notifier).update((state) => task!.date);
      ref.read(switchProvider.notifier).update((state) => true);
    }
    switch (task!.priority) {
      case Priority.none:
        ref
            .read(dropdownValueProvider.notifier)
            .update((state) => priorityList[0]);
        break;
      case Priority.low:
        ref
            .read(dropdownValueProvider.notifier)
            .update((state) => priorityList[1]);
        break;
      case Priority.high:
        ref
            .read(dropdownValueProvider.notifier)
            .update((state) => priorityList[2]);
        break;
    }
  }

  Priority _dropdownValueToPriority() {
    Priority? pr;
    switch (ref.read(dropdownValueProvider)) {
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
    MyLogger.l.d('Go back button pressed. Task page closing');
    locator.get<NavigationManager>().pop(task);
  }

  void _onDelete() async {
    if (await _promptUser()) {
      MyLogger.l.d('Task page closing');
      locator.get<NavigationManager>().pop(
            Task(task!.id),
          );
    }
  }

  void _onSave() {
    MyLogger.l.d('Save button pressed');
    if (textController!.text != '') {
      MyLogger.l.d('Task page closing');
      locator.get<NavigationManager>().pop(
            Task(
              task!.id,
              textController!.text,
              _dropdownValueToPriority(),
              task!.done,
              ref.read(dateProvider),
            ),
          );
    } else {
      MyLogger.l.d('Task is empty');
      _onDelete();
    }
  }

  Future<bool> _promptUser() async {
    MyLogger.l.d('Asking for deletion/going back');
    return await showDialog<bool>(
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(isNewTask!
                  ? 'You can\'t make empty task! Are you want to go back?'
                  : 'Are you sure you want to Delete this task?'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    MyLogger.l.d('Deletion/going back cancelled');
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Ok'),
                  onPressed: () {
                    MyLogger.l.d('Deletion/going back confirmed');
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
      body: CustomScrollView(
        controller: ScrollController(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            leading: CloseButton(
              onPressed: () {
                _onGoBack();
              },
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _onSave();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).primaryColor),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Material(
                borderRadius: BorderRadius.circular(8.0),
                elevation: 2,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Task to do',
                    filled: true,
                    fillColor: Theme.of(context).canvasColor,
                  ),
                  autofocus: false,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  minLines: 4,
                  controller: textController,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Priority',
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    selectedItemBuilder: (BuildContext context) {
                      return priorityList.map<Widget>((String item) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          constraints: const BoxConstraints(minWidth: 100),
                          child: Text(
                            item,
                            style: TextStyle(
                              color: item == '!!High'
                                  ? Theme.of(context).textTheme.headlineMedium!.color
                                  : Theme.of(context).textTheme.headlineSmall!.color,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    items: priorityList.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(
                            color: items == '!!High'
                                ? Theme.of(context).textTheme.headlineMedium!.color
                                : Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      MyLogger.l.d('Priority chosen');
                      ref
                          .read(dropdownValueProvider.notifier)
                          .update((state) => value!);
                    },
                    value: ref.watch(dropdownValueProvider),
                    icon: const Visibility(
                      visible: false,
                      child: Icon(
                        Icons.accessible,
                      ),
                    ),
                    isExpanded: true,
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Make by date',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        ref.watch(dateProvider) != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(ref.watch(dateProvider)!)
                            : '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Switch(
                    value: ref.watch(switchProvider),
                    activeColor: Theme.of(context).iconTheme.color,
                    onChanged: (bool value) async {
                      MyLogger.l.d('Make by date switch changed');
                      ref
                          .read(switchProvider.notifier)
                          .update((state) => value);
                      if (value) {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          MyLogger.l.d('Date set');
                          ref
                              .read(dateProvider.notifier)
                              .update((state) => pickedDate);
                        } else {
                          MyLogger.l.d("Date wasn't selected");
                          ref
                              .read(switchProvider.notifier)
                              .update((state) => false);
                        }
                      } else {
                        MyLogger.l.d('Make by date turned off');
                        ref.read(dateProvider.notifier).update((state) => null);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: TextButton.icon(
                onPressed: isNewTask!
                    ? null
                    : () {
                        MyLogger.l.d('Delete button pressed');
                        _onDelete();
                      },
                icon: Icon(
                  Icons.delete,
                  color: isNewTask!
                      ? Theme.of(context).textTheme.titleSmall!.color
                      : Theme.of(context).textTheme.headlineMedium!.color,
                ),
                label: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 16,
                    color: isNewTask!
                        ? Theme.of(context).textTheme.titleSmall!.color
                        : Theme.of(context).textTheme.headlineMedium!.color,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
