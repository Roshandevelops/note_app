import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_app/model/todo__model.dart';
import "package:http/http.dart" as http;

abstract class TodoServices {
  Future<void> addData(
      TodoModel todoModel, BuildContext context, Function onSuccess);
}

class TodoDb extends ChangeNotifier implements TodoServices {
  TodoDb.internal();
  static TodoDb instance = TodoDb.internal();
  factory TodoDb() {
    return TodoDb.instance;
  }

  @override
  Future<void> addData(
      TodoModel todoModel, BuildContext context, Function onSuccess) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.nstack.in/v1/todos"),
        body: jsonEncode(todoModel.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        onSuccess();
        //  widget.onTap!;

        Navigator.of(context).pop();
        notifyListeners();
      }
    } catch (e) {
      print("Error");
    }
  }
}
