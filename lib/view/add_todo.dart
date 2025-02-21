import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  const AddTodo({super.key, this.onTap, this.todo});

  final void Function()? onTap;
  final Map? todo;

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController descriptiontEditingController =
      TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final editTitle = todo["title"];
      final editDescription = todo["description"];
      titleEditingController.text = editTitle;
      descriptiontEditingController.text = editDescription;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Todo" : "Add Todo"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextFormField(
              controller: titleEditingController,
              minLines: 1,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: descriptiontEditingController,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "Content",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                isEdit ? updateButtonClicked() : submitButtonClicked();
              },
              child: Text(
                isEdit ? "Update" : "Submit",
              ),
            ),
          ],
        ),
      )),
    );
  }

  void submitButtonClicked() async {
    final titleController = titleEditingController.text;
    final descriptiontController = descriptiontEditingController.text;

    final bodyAsJson = {
      "title": titleController,
      "description": descriptiontController,
      "is_completed": false
    };

    final response = await http.post(
      Uri.parse("https://api.nstack.in/v1/todos"),
      body: jsonEncode(bodyAsJson),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      titleEditingController.clear();
      descriptiontEditingController.clear();
      widget.onTap!();
      showSnackBarrr("Success", Colors.green);

      Navigator.of(context).pop();
      log(response.body);
    } else {
      showSnackBarrr("Error", Colors.yellow);
      log(response.body);
    }
  }

  Future<void> updateButtonClicked() async {
    final todo = widget.todo;
    if (todo == null) {
      print("you cant update without totdo data");
      return;
    }
    final id = todo["_id"];
    //  final iscompleted = todo["is_completed"];
    final titleController = titleEditingController.text;
    final descriptiontController = descriptiontEditingController.text;

    final bodyAsJson = {
      "title": titleController,
      "description": descriptiontController,
      "is_completed": false
      //  iscompleted
    };

    final response = await http.put(
      Uri.parse("https://api.nstack.in/v1/todos/$id"),
      body: jsonEncode(bodyAsJson),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // titleEditingController.clear();
      // descriptiontEditingController.clear();
      widget.onTap!();
      showSnackBarrr("updation success", Colors.green);

      Navigator.of(context).pop();
      log(response.body);
    } else {
      showSnackBarrr(" updation Error", Colors.yellow);
      log(response.body);
    }
  }

  void showSnackBarrr(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.all(20),
        content: Text(message),
      ),
    );
  }
}
