import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:to_do_list/domain/data_manager.dart';
import 'package:to_do_list/navigation/navigation.dart';
import 'package:to_do_list/repository/network_manager.dart';
import 'package:to_do_list/repository/persistence_manager.dart';
import 'package:to_do_list/token.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<NavigationManager>(
    () => NavigationManager(),
  );
  locator.registerLazySingleton<DataManager>(
    () => DataManager(
      NetworkManager(token, Dio()),
      PersistenceManager(),
    ),
  );
}
