import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/domain/utils.dart';
import 'package:to_do_list/firebase_options.dart';
import 'package:to_do_list/navigation/navigation.dart';
import 'package:to_do_list/navigation/routes.dart';
import 'package:to_do_list/theme/theme_constants.dart';

import 'locator.dart';

void main() async {
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    MyLogger.l.d('Error in FlutterError');
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    MyLogger.l.d('Error in PlatformDispatcher');
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    );
    return true;
  };
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: RouteNames.initialRoute,
        onGenerateRoute: RoutesBuilder.onGenerateRoute,
        onUnknownRoute: RoutesBuilder.onUnknownRoute,
        navigatorKey: locator.get<NavigationManager>().key,
      ),
    ),
  );
}
