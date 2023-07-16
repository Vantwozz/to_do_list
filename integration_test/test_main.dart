import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/locator.dart';
import 'package:to_do_list/navigation/navigation.dart';
import 'package:to_do_list/navigation/routes.dart';

void main() {
  setup();
  runApp(
    ProviderScope(
      child: MaterialApp(
        initialRoute: RouteNames.initialRoute,
        onGenerateRoute: RoutesBuilder.onGenerateRoute,
        onUnknownRoute: RoutesBuilder.onUnknownRoute,
        navigatorKey: locator.get<NavigationManager>().key,
      ),
    ),
  );
}