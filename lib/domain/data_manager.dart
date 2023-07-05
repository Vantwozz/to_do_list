import 'package:flutter/material.dart';
import 'package:to_do_list/domain/utils.dart';
import 'package:to_do_list/token.dart';
import 'package:to_do_list/repository/network_manager.dart';
import 'package:to_do_list/repository/persistence_manager.dart';
import 'package:uuid/uuid.dart';

class DataManager {
  DataManager();

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

  Future<bool> deleteTaskById(String id) async {
    bool ans = true;
    if (_connection!) {
      try {
        await networkManager.deleteTaskById(id);
      } catch (exception) {
        ans = false;
      }
    }
    await persistenceManager.deleteTask(id: id);
    return ans;
  }

  Future<bool> createTask(Task task) async {
    bool ans = true;
    if (_connection!) {
      try {
        await networkManager.createTask(task);
      } catch (exception) {
        ans = false;
      }
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
    return ans;
  }

  Future<bool> updateTask(Task task) async {
    bool ans = true;
    if (_connection!) {
      try {
        await networkManager.changeTask(task);
      } catch (exception) {
        ans = false;
      }
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
    return ans;
  }

  Future<bool> uploadFromLocal() async {
    bool ans = true;
    try {
      await networkManager.patchList(await persistenceManager.getList());
    } catch (exception) {
      ans = false;
    }
    return ans;
  }

  Future<bool> downloadToLocal() async {
    bool ans = true;
    try {
      await persistenceManager.updateList(
          list: await networkManager.getFullList());
    } catch (exception) {
      ans = false;
    }
    return ans;
  }
}
