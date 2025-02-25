import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:to_do_app/model/todo__model.dart';
import "package:http/http.dart" as http;

abstract class TodoServices {
  Future<dynamic> addData(
      TodoModel todoModel, BuildContext context, Function onSuccess);
  Future<void> fetchTodoItems();
}

class TodoDb extends ChangeNotifier implements TodoServices {
  TodoDb.internal();
  static TodoDb instance = TodoDb.internal();
  factory TodoDb() {
    return TodoDb.instance;
  }

  @override
  Future<dynamic> addData(
      TodoModel todoModel, BuildContext context, Function onSuccess) async {
    final response = await http.post(
      Uri.parse("https://api.nstack.in/v1/todos"),
      body: jsonEncode(todoModel.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      onSuccess();

      Navigator.of(context).pop();
      notifyListeners();
    }
    return response;
  }

  @override
  Future<void> fetchTodoItems() async {
    final response = await http.get(
      Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=20"),
      headers: {"accpet": "application/json"},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      // setState(
      //   () {
      //     items = result;
      //   },
      // );
    }
  }
}
