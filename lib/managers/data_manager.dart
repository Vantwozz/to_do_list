import 'package:flutter/material.dart';
import 'package:to_do_list/utils/utils.dart';
import 'package:to_do_list/utils/token.dart';
import 'package:to_do_list/managers/network_manager.dart';
import 'package:to_do_list/managers/persistence_manager.dart';

class DataManager{
  DataManager._();

  static final manager = DataManager._();

  final networkManager = NetworkManager(token);
  final persistenceManager = PersistenceManager();

}
