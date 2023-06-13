import 'package:flutter/material.dart';
import 'package:to_do_list/pages/tasks/taskpage.dart';
import 'package:to_do_list/utils/uils.dart';
import 'package:intl/intl.dart';

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
      toDoList.removeAt(index);
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
                        Color textColor;
                        TextDecoration decoration;
                        if (toDoList[index].done) {
                          decoration = TextDecoration.lineThrough;
                          textColor = const Color.fromRGBO(0, 0, 0, 0.3);
                        } else {
                          textColor = const Color.fromRGBO(0, 0, 0, 1);
                          decoration = TextDecoration.none;
                        }
                        final textToShow = Text(toDoList[index].text!,
                            style: TextStyle(
                                decoration: decoration,
                                color: textColor,
                                fontSize: 16),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis);
                        Color iconColor;
                        Icon showIcon;
                        switch (toDoList[index].priority) {
                          case Priority.none:
                            showIcon = const Icon(null);
                            break;
                          case Priority.low:
                            showIcon = const Icon(Icons.arrow_downward);
                            break;
                          case Priority.high:
                            showIcon = const Icon(
                              Icons.accessible,
                              color: Color.fromRGBO(255, 58, 48, 1),
                            );
                            break;
                        }
                        return Dismissible(
                          key: UniqueKey(),
                          secondaryBackground: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: AlignmentDirectional.centerStart,
                            color: Colors.red.shade300,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          background: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: AlignmentDirectional.centerEnd,
                            color: Colors.lightGreen,
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              handleDismiss(direction, index);
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
                          child: Material(
                            color: Colors.white,
                            borderRadius: index == 0
                                ? const BorderRadius.vertical(
                                    bottom: Radius.circular(0.0),
                                    top: Radius.circular(8.0))
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: toDoList[index].done,
                                        onChanged: (bool? value) {},
                                      ),
                                      showIcon,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            textToShow,
                                            Visibility(
                                              visible:
                                                  toDoList[index].date == null
                                                      ? false
                                                      : true,
                                              child: Text(
                                                toDoList[index].date != null
                                                    ? DateFormat('yyyy-MM-dd')
                                                        .format(toDoList[index]
                                                            .date!)
                                                    : '',
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.3),
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.info_outline)),
                              ],
                            ),
                          ),
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
