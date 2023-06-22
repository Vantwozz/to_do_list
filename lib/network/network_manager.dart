import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:to_do_list/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:to_do_list/utils/token.dart';

class NetworkManager {
  NetworkManager._(this._token) {
    _dio.options.headers["Authorization"] = "Bearer $_token";
  }

  int? _revision;
  final String _token;
  final _dio = Dio();

  final String _url = ' https://beta.mrdekk.ru/todobackend/list';

  final _uuid = const Uuid();

  static final manager = NetworkManager._(token);

  String generateUuid() {
    return _uuid.v4();
  }

  Future<List<AdvancedTask>> getFullList() async {
    final response = await _dio.get<Map<String, dynamic>>(
      'https://beta.mrdekk.ru/todobackend/list',
    );
    List<AdvancedTask> ans = [];
    if (response.statusCode == 200) {
      Map<String, dynamic>? data = response.data;
      if (data != null) {
        List<Map<String, dynamic>> list = data['list'];
        for (int i = 0; i < list.length; i++) {
          ans.add(AdvancedTask.fromJson(list[i]));
        }
      }
    }
    return ans;
  }
}
