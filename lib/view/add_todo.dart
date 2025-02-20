import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController contentEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
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
              controller: contentEditingController,
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
                submitButtonClicked();
              },
              child: Text("Submit"),
            ),
          ],
        ),
      )),
    );
  }

  // Future<void> subMitButtonClicked() async {
  //   final title = titleEditingController.text;
  //   final content = contentEditingController.text;
  //   final body = {
  //     "title": title,
  //     "description": content,
  //     "is_completed": false
  //   };
  //   final response = await http.post(
  //     Uri.parse("https://api.nstack.in/v1/todos"),
  //     body: jsonEncode(body),
  //     headers: {'Content-Typ': 'application/json'},
  //   );

  //   if (response.statusCode == 201) {
  //     titleEditingController.text = " ";
  //     contentEditingController.text = " ";
  //     print(response.body);
  //   }
  // }

  void submitButtonClicked() async {
    final titleController = titleEditingController.text;
    final contentController = contentEditingController.text;

    final bodyAsJson = {
      "title": titleController,
      "description": contentController,
      "is_completed": false
    };

    final response = await http.post(
      Uri.parse("https://api.nstack.in/v1/todos"),
      body: jsonEncode(bodyAsJson),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      showSnackBarrr("Success");
      Navigator.of(context).pop();
      log(response.body);
    } else {
      showSnackBarrr("Error");
      log(response.body);
    }
  }

  void showSnackBarrr(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.all(20),
        content: Text(message),
      ),
    );
  }
}
