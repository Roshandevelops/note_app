import 'package:flutter/material.dart';
import 'package:to_do_app/model/todo__model.dart';
import 'package:to_do_app/services/todo_services.dart';

class TodoProvider with ChangeNotifier {
  Future<void> addTodoData(
      BuildContext context, TodoModel todoModel, Function onSuccess) async {
    await TodoDb.instance.addData(todoModel, context, onSuccess);
  }
}
