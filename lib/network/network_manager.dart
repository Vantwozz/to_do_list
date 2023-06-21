import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_list/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:to_do_list/utils/token.dart';

class NetworkManager{
  NetworkManager._(this._token);
  int? _revision;
  final String _token;

  final String _url = ' https://beta.mrdekk.ru/todobackend/list';

  final _uuid = const Uuid();

  static final manager = NetworkManager._(token);

  String generateUuid(){
    return _uuid.v4();
  }

  List<Task> getFullList() async {
    final response = await http.get(
      Uri.parse('https://beta.mrdekk.ru/todobackend/list'),
      headers: {"Authorization": "Bearer $_token"},
    );
    return;
  }
}