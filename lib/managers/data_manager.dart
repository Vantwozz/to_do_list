import 'package:flutter/material.dart';
import 'package:to_do_list/utils/utils.dart';
import 'package:to_do_list/utils/token.dart';
import 'package:to_do_list/managers/network_manager.dart';
import 'package:to_do_list/managers/persistence_manager.dart';
import 'package:uuid/uuid.dart';

class DataManager {
  DataManager._();

  Future<bool> checkConnection() async {
    try {
      await networkManager.checkConnection();
      _connection = true;
      return true;
    } catch (exception) {
      _connection = false;
      return false;
    }
  }

  static final manager = DataManager._();

  final networkManager = NetworkManager(token);
  final persistenceManager = PersistenceManager();
  bool? _connection;
  final _uuid = const Uuid();

  Future<bool> equalLists() async {
    var list1 = await networkManager.getFullList();
    var list2 = await persistenceManager.getList();
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (!(list1[i] == list2[i])) {
        return false;
      }
    }
    return true;
  }

  String generateUuid() {
    return _uuid.v4();
  }

  Future<List<AdvancedTask>> getList() async {
    if (_connection!) {
      return await networkManager.getFullList();
    } else {
      return await persistenceManager.getList();
    }
  }

  Future<AdvancedTask?> getTaskById(String id) async {
    if (_connection!) {
      return await networkManager.getTaskById(id);
    } else {
      return await persistenceManager.getTask(id: id);
    }
  }

  Future<void> deleteTaskById(String id) async {
    if (_connection!) {
      await networkManager.deleteTaskById(id);
    }
    await persistenceManager.deleteTask(id: id);
  }

  Future<void> createTask(Task task) async {
    if (_connection!) {
      await networkManager.createTask(task);
    }
    await persistenceManager.insertTask(
      task: AdvancedTask(
        id: task.id,
        text: task.text!,
        importance: networkManager.getImportance(task.priority),
        done: task.done,
        deadline: task.date == null
            ? null
            : task.date!.millisecondsSinceEpoch.toInt(),
        color: "#FFFFFF",
        createdAt: DateTime.now().millisecondsSinceEpoch.toInt(),
        changedAt: DateTime.now().millisecondsSinceEpoch.toInt(),
        lastUpdatedBy: "1",
      ),
    );
  }

  Future<void> updateTask(Task task) async {
    if (_connection!) {
      await networkManager.changeTask(task);
    }
    await persistenceManager.updateTask(
      task: AdvancedTask(
        id: task.id,
        text: task.text!,
        importance: networkManager.getImportance(task.priority),
        done: task.done,
        deadline: task.date == null
            ? null
            : task.date!.millisecondsSinceEpoch.toInt(),
        color: "#FFFFFF",
        createdAt: DateTime.now().millisecondsSinceEpoch.toInt(),
        changedAt: DateTime.now().millisecondsSinceEpoch.toInt(),
        lastUpdatedBy: "1",
      ),
    );
  }

  Future<void> uploadFromLocal() async {
    await networkManager.patchList(await persistenceManager.getList());
  }

  Future<void> downloadToLocal() async {
    await persistenceManager.updateList(
        list: await networkManager.getFullList());
  }
}
