import 'package:flutter/material.dart';
import 'package:to_do_list/pages/taskpage.dart';
import 'package:to_do_list/include/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> toDoList = [
    Task('something', Priority.none, false),
    Task('another task', Priority.low, false, DateTime.now())
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  handleDismiss(DismissDirection direction, int index) async {
    final swiped = toDoList[index];
    String action;

    if (direction == DismissDirection.startToEnd) {
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
    } else {
      toDoList[index].done = true;
    }
  }

  Future<bool?> promptUser(direction) async {
    String action;
    if (direction == DismissDirection.startToEnd) {
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
                      padding: const EdgeInsets.only(top: 0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            alignment: AlignmentDirectional.centerStart,
                            color: Colors.red.shade300,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          secondaryBackground: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
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
                          confirmDismiss: (direction) =>
                              promptUser(direction),
                          child: Material(
                            color: Colors.white,
                            borderRadius: index == 0
                                ? const BorderRadius.vertical(
                                    bottom: Radius.circular(0.0),
                                    top: Radius.circular(8.0))
                                : null,
                            child:
                                ListTile(title: Text(toDoList[index].text!)),
                          ),
                        );
                      },
                      itemCount: toDoList.length,
                    ),
                    Material(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(0.0),
                          bottom: Radius.circular(8.0)),
                      child: TextButton(
                        onPressed: () {
                          return;
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white),
                        child: const Text('Add'),
                      )
                    ),
                  ],
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}
