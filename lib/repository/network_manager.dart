import 'package:dio/dio.dart';
import 'package:to_do_list/domain/utils.dart';
import 'package:to_do_list/token.dart';

class NetworkManager {
  NetworkManager(this._token, this._dio) {
    _dio.options.headers["Authorization"] = "Bearer $_token";
    _revisionGetter();
  }

  Future<void> checkConnection() async {
    await _dio.get(_url);
  }

  void _revisionGetter() async {
    await getRevision();
  }

  int? _revision;
  final String _token;
  final Dio _dio;
  final String _url = url;

  Future<void> getRevision() async {
    final response = await _dio.get(_url);
    _revision = response.data["revision"];
  }

  String getImportance(Priority pr) {
    String importance;
    switch (pr) {
      case Priority.none:
        importance = "basic";
        break;
      case Priority.low:
        importance = "low";
        break;
      case Priority.high:
        importance = "important";
        break;
      default:
        importance = "basic";
    }
    return importance;
  }

  Future<List<AdvancedTask>> getFullList() async {
    final response = await _dio.get<Map<String, dynamic>>(_url);
    List<AdvancedTask> ans = [];
    if (response.statusCode == 200) {
      Map<String, dynamic>? data = response.data;
      if (data != null) {
        List<dynamic> list = data['list'];
        for (int i = 0; i < list.length; i++) {
          ans.add(AdvancedTask.fromJson(list[i]));
        }
      }
    }
    return ans;
  }

  Future<bool> createTask(Task task) async {
    _dio.options.headers["X-Last-Known-Revision"] = _revision;
    String importance = getImportance(task.priority);
    var data = {
      "element": {
        "id": task.id,
        "text": task.text,
        "importance": importance,
        "done": task.done,
        "deadline": task.date == null
            ? null
            : task.date!.millisecondsSinceEpoch.toInt(),
        "color": "#FFFFFF",
        "created_at": DateTime.now().millisecondsSinceEpoch.toInt(),
        "changed_at": DateTime.now().millisecondsSinceEpoch.toInt(),
        "last_updated_by": "1"
      },
    };
    if (task.date == null) {
      data["element"]!.remove("deadline");
    }
    final response = await _dio.post(
      _url,
      data: data,
    );
    _dio.options.headers.remove("X-Last-Known-Revision");
    _revision = _revision! + 1;
    return (response.statusCode == 200);
  }

  Future<AdvancedTask?> getTaskById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_url/$id',
    );
    AdvancedTask? task;
    if (response.statusCode == 200) {
      dynamic data = response.data;
      if (data != null) {
        task = AdvancedTask.fromJson(data["element"]);
        return task;
      }
    }
    return null;
  }

  Future<bool> deleteTaskById(String id) async {
    _dio.options.headers["X-Last-Known-Revision"] = _revision;
    final response = await _dio.delete('$_url/$id');
    _revision = _revision! + 1;
    _dio.options.headers.remove("X-Last-Known-Revision");
    return (response.statusCode == 200);
  }

  Future<bool> saveTask(AdvancedTask task) async {
    _dio.options.headers["X-Last-Known-Revision"] = _revision;
    var data = {
      "element": {
        "id": task.id,
        "text": task.text,
        "importance": task.importance,
        "done": task.done,
        "deadline": task.deadline,
        "color": "#FFFFFF",
        "created_at": task.createdAt,
        "changed_at": DateTime.now().millisecondsSinceEpoch.toInt(),
        "last_updated_by": "1"
      },
    };
    if (task.deadline == null) {
      data["element"]!.remove("deadline");
    }
    final response = await _dio.put(
      '$_url/${task.id}',
      data: data,
    );
    _revision = _revision! + 1;
    _dio.options.headers.remove("X-Last-Known-Revision");
    return (response.statusCode == 200);
  }

  Future<bool> changeTask(Task task) async {
    AdvancedTask? advTask = await getTaskById(task.id);
    if (advTask != null) {
      advTask.importance = getImportance(task.priority);
      advTask.deadline =
          task.date == null ? null : task.date!.millisecondsSinceEpoch.toInt();
      advTask.done = task.done;
      advTask.text = task.text!;
      return saveTask(advTask);
    }
    return false;
  }

  Future<bool> patchList(List<AdvancedTask> list) async {
    _dio.options.headers["X-Last-Known-Revision"] = _revision;
    Map<String, dynamic> data = {"list": []};
    for (int i = 0; i < list.length; i++) {
      if (list[i].deadline != null) {
        data['list'].add({
          "id": list[i].id,
          "text": list[i].text,
          "importance": list[i].importance,
          "done": list[i].done,
          "deadline": list[i].deadline,
          "color": "#FFFFFF",
          "created_at": list[i].createdAt,
          "changed_at": DateTime.now().millisecondsSinceEpoch.toInt(),
          "last_updated_by": "1"
        });
      } else {
        data['list'].add({
          "id": list[i].id,
          "text": list[i].text,
          "importance": list[i].importance,
          "done": list[i].done,
          "color": "#FFFFFF",
          "created_at": list[i].createdAt,
          "changed_at": DateTime.now().millisecondsSinceEpoch.toInt(),
          "last_updated_by": "1"
        });
      }
    }
    final response = await _dio.patch(
      'https://beta.mrdekk.ru/todobackend/list',
      data: data,
    );
    _revision = _revision! + 1;
    _dio.options.headers.remove("X-Last-Known-Revision");
    return (response.statusCode == 200);
  }
}
