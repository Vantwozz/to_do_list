import 'package:flutter/material.dart';
import 'package:to_do_list/pages/unknown_page.dart';
import 'package:to_do_list/pages/home/homepage.dart';
import 'package:to_do_list/pages/tasks/taskpage.dart';
import 'package:to_do_list/utils/utils.dart';

abstract class RouteNames {
  const RouteNames._();

  static const initialRoute = home;

  static const home = '/';
  static const task = '/task';
}

abstract class RoutesBuilder {
  const RoutesBuilder._();

  static final routes = <String, Widget Function(BuildContext)>{
    RouteNames.home: (_) => const HomePage(),
    RouteNames.task: (context) => TaskPage(
          task: ModalRoute.of(context)?.settings.arguments as Task,
        ),
  };

  static Route<Object?>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );

      case RouteNames.task:
        return MaterialPageRoute<Task?>(
          builder: (_) => TaskPage(
            task: settings.arguments as Task,
          ),
          settings: settings,
        );
    }
    return null;
  }

  static Route<Object?>? onUnknownRoute<T>(RouteSettings settings) {
    return MaterialPageRoute<T>(
      builder: (context) => UnknownPage(
        routeName: settings.name,
      ),
      settings: settings,
    );
  }
}
