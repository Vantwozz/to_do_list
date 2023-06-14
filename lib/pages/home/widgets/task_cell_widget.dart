import 'package:flutter/material.dart';
import 'package:to_do_list/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TaskCellWidget extends StatefulWidget {
  const TaskCellWidget({
    required this.task,
    this.borderRadius,
    required this.checkBoxChanged,
    required this.onDismissed,
    required this.confirmDismiss,
    required this.onInfoPressed,
    required Key? key,
  }) : super(key: key);
  final Task task;
  final BorderRadius? borderRadius;
  final Function(bool? value) checkBoxChanged;
  final Function(DismissDirection direction) confirmDismiss;
  final Function(DismissDirection direction) onDismissed;
  final Function() onInfoPressed;

  @override
  State<TaskCellWidget> createState() => _TaskCellWidgetState();
}

class _TaskCellWidgetState extends State<TaskCellWidget> {
  Task? task;

  @override
  void initState() {
    task = widget.task;
    // TODO: implement initState
    super.initState();
  }

  Color _getColor(Set<MaterialState> states) {
    if(task!.done){
      return const Color.fromRGBO(52, 199, 89, 1);
    }else if (task!.priority == Priority.high) {
      return const Color.fromRGBO(255, 49, 48, 1);
    } else {
      return const Color.fromRGBO(0, 0, 0, 0.3);
    }
  }

  Visibility _getIconToShow() {
    Icon showIcon;
    bool visible = false;
    switch (task!.priority) {
      case Priority.none:
        showIcon = const Icon(null);
        break;
      case Priority.low:
        showIcon = const Icon(Icons.arrow_downward);
        visible = true;
        break;
      case Priority.high:
        showIcon = Icon(
          MdiIcons.exclamation,
          color: const Color.fromRGBO(255, 58, 48, 1),
        );
        visible = true;
        break;
    }
    return Visibility(
      visible: visible,
      child: showIcon,
    );
  }

  Text _getTextToShow() {
    Color textColor;
    TextDecoration decoration;
    if (task!.done) {
      decoration = TextDecoration.lineThrough;
      textColor = const Color.fromRGBO(0, 0, 0, 0.3);
    } else {
      textColor = const Color.fromRGBO(0, 0, 0, 1);
      decoration = TextDecoration.none;
    }
    return Text(
      task!.text!,
      style: TextStyle(
        decoration: decoration,
        color: textColor,
        fontSize: 16,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.key!,
      secondaryBackground: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerEnd,
        color: const Color.fromRGBO(255, 59, 48, 1),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerStart,
        color: const Color.fromRGBO(52, 199, 89, 1),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) => widget.onDismissed(direction),
      confirmDismiss: (direction) => widget.confirmDismiss(direction),
      child: Material(
        color: Colors.white,
        borderRadius: widget.borderRadius,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: task!.done,
                    onChanged: (bool? value) => widget.checkBoxChanged(value),
                    fillColor: MaterialStateColor.resolveWith(_getColor),
                  ),
                  _getIconToShow(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _getTextToShow(),
                        Visibility(
                          visible: task!.date == null ? false : true,
                          child: Text(
                            task!.date != null
                                ? DateFormat('yyyy-MM-dd').format(task!.date!)
                                : '',
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
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
              onPressed: () => widget.onInfoPressed(),
              icon: const Icon(
                Icons.info_outline,
                color: Color.fromRGBO(0, 0, 0, 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
