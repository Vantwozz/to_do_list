import 'package:get_it/get_it.dart';
import 'package:to_do_list/domain/data_manager.dart';
import 'package:to_do_list/navigation/navigation.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<NavigationManager>(() => NavigationManager());
  locator.registerLazySingleton<DataManager>(() => DataManager());
}
