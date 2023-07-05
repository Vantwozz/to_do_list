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
    logger.l.d('Task page opened');
    task = widget.task;
    isNewTask = task!.text == null;
    _initTask();
    taskName = task!.text;
    textController = TextEditingController(text: taskName);
    // TODO: implement initState
    super.initState();
  }

  Future<void> _initTask() async {
    await Future.delayed(const Duration(microseconds: 10) );
    if (task!.date != null) {
      ref.read(switchProvider.notifier).update((state) => true);
      ref.read(dateProvider.notifier).update((state) => task!.date);
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
    logger.l.d('Go back button pressed. Task page closing');
    locator.get<NavigationManager>().pop(task);
  }

  void _onDelete() async {
    if (await _promptUser()) {
      logger.l.d('Task page closing');
      locator.get<NavigationManager>().pop(
            Task(task!.id),
          );
    }
  }

  void _onSave() {
    logger.l.d('Save button pressed');
    if (textController!.text != '') {
      logger.l.d('Task page closing');
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
      logger.l.d('Task is empty');
      _onDelete();
    }
  }

  Future<bool> _promptUser() async {
    logger.l.d('Asking for deletion/going back');
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
                    logger.l.d('Deletion/going back cancelled');
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Ok'),
                  onPressed: () {
                    logger.l.d('Deletion/going back confirmed');
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
            backgroundColor: const Color(0xFFf7f6f2),
            leading: CloseButton(
              onPressed: () {
                _onGoBack();
              },
              color: Colors.black,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _onSave();
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Color(0xFF007AFF),
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
                    fillColor: Colors.white,
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
                                  ? const Color.fromRGBO(255, 59, 48, 1)
                                  : const Color.fromRGBO(0, 0, 0, 0.3),
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
                                ? const Color(0xFFFF3B30)
                                : const Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      logger.l.d('Priority chosen');
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
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF007AFF),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Switch(
                    value: ref.watch(switchProvider),
                    onChanged: (bool value) async {
                      logger.l.d('Make by date switch changed');
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
                          logger.l.d('Date set');
                          ref
                              .read(dateProvider.notifier)
                              .update((state) => pickedDate);
                        } else {
                          logger.l.d('Date wasn\'t selected');
                          ref
                              .read(switchProvider.notifier)
                              .update((state) => false);
                        }
                      } else {
                        logger.l.d('Make by date turned off');
                        ref.read(dateProvider.notifier).update((state) => null);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(color: Color.fromRGBO(0, 0, 0, 0.2)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: TextButton.icon(
                onPressed: isNewTask!
                    ? null
                    : () {
                        logger.l.d('Delete button pressed');
                        _onDelete();
                      },
                icon: Icon(
                  Icons.delete,
                  color: isNewTask!
                      ? const Color.fromRGBO(0, 0, 0, 0.15)
                      : const Color(0xFFFF3B30),
                ),
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
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFf7f6f2),
    );
  }
}
