import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:to_do_app/model/todo__model.dart';
import "package:http/http.dart" as http;

abstract class TodoServices {
  Future<dynamic> addData(
      TodoModel todoModel, BuildContext context, Function onSuccess);
  Future<dynamic> fetchTodoItems();
  Future<List> deleteById(String id, dynamic items);
  Future<dynamic> editData(
      Map? todo,
      TextEditingController titleEdit,
      TextEditingController descriptionEdit,
      BuildContext context,
      Function()? onTap);
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

      if (context.mounted) {
        Navigator.of(context).pop();
      }

      notifyListeners();
    }
    return response;
  }

  @override
  Future<dynamic> fetchTodoItems() async {
    final response = await http.get(
      Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=20"),
      headers: {"accpet": "application/json"},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;

      return result;
    }
    notifyListeners();
  }

  @override
  Future<List> deleteById(String id, dynamic items) async {
    final response =
        await http.delete(Uri.parse("https://api.nstack.in/v1/todos/$id"));
    final filteredItems = items.where((e) => e["_id"] != id).toList();

    if (response.statusCode == 200) {
      log(response.body);
      log("working");
    } else {
      log("cant delete");
    }
    return filteredItems;
  }

  @override
  Future<dynamic> editData(
      Map? todo,
      TextEditingController titleEdit,
      TextEditingController descriptionEdit,
      BuildContext context,
      Function()? onTap) async {
    final todoSample = todo;
    if (todoSample == null) {
      log("you cant update without totdo data");
      return;
    }
    final id = todoSample["_id"];
    final titleController = titleEdit.text;
    final descriptiontController = descriptionEdit.text;
    final bodyAsJson = {
      "title": titleController,
      "description": descriptiontController,
      "is_completed": false
    };
    final response = await http.put(
      Uri.parse("https://api.nstack.in/v1/todos/$id"),
      body: jsonEncode(bodyAsJson),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      onTap!();
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      log(response.body);
    } else {
      log(response.body);
    }
    notifyListeners();
    return response;
  }
}
