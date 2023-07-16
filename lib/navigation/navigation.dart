import 'package:flutter/material.dart';
import 'package:to_do_list/domain/utils.dart';
import 'package:to_do_list/navigation/routes.dart';

class NavigationManager {
  NavigationManager();

  final key = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => key.currentState!;

  Future<Task?> openTask(Task task) {
    return _navigator.pushNamed<Task?>(
      RouteNames.task,
      arguments: task,
    );
  }

  void pop<T extends Object>([T? result]) {
    _navigator.pop(result);
  }

  void popToHome() {
    _navigator.popUntil(ModalRoute.withName(RouteNames.home));
  }
}
