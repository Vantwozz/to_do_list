import 'package:flutter/material.dart';
import 'package:to_do_list/navigation/navigation.dart';
import 'package:to_do_list/navigation/routes.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: RouteNames.initialRoute,
      onGenerateRoute: RoutesBuilder.onGenerateRoute,
      onUnknownRoute: RoutesBuilder.onUnknownRoute,
      navigatorKey: NavigationManager.instance.key,
    )
  );
}