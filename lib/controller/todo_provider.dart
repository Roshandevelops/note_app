import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:to_do_app/model/todo__model.dart';
import 'package:to_do_app/services/todo_services.dart';

class TodoProvider with ChangeNotifier {
  List newFetchedItems = [];

  Future<void> addTodoData(BuildContext context, TodoModel todoModel,
      void Function() onSuccess) async {
    await TodoDb.instance.addData(todoModel, context, onSuccess);
  }

  Future<void> getData() async {
    final fetchedItems = await TodoDb.instance.fetchTodoItems();
    newFetchedItems = fetchedItems;
    log(newFetchedItems.toString());
    notifyListeners();
  }

  Future<void> deleteItemFromServer(String id, dynamic items) async {
    final result = await TodoDb.instance.deleteById(id, items);
    newFetchedItems = result;
    notifyListeners();
  }

  Future<void> editTodoData(
    Map? todo,
    TextEditingController titleEdit,
    TextEditingController descriptionEdit,
    BuildContext context,
    Function()? onTap,
  ) async {
    await TodoDb.instance
        .editData(todo, titleEdit, descriptionEdit, context, onTap);
    notifyListeners();
  }
}
