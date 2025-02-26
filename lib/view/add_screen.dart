import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:to_do_app/controller/todo_provider.dart';
import 'package:to_do_app/model/todo__model.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key, this.onTap, this.todo});

  final void Function()? onTap;
  final Map? todo;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
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
                isEdit
                    ? Provider.of<TodoProvider>(context, listen: false)
                        .editTodoData(
                        widget.todo,
                        titleEditingController,
                        descriptiontEditingController,
                        context,
                        widget.onTap,
                      )
                    : Provider.of<TodoProvider>(context, listen: false)
                        .addTodoData(
                            context,
                            TodoModel(
                              title: titleEditingController.text,
                              description: descriptiontEditingController.text,
                              iscompleted: false,
                            ),
                            widget.onTap!);
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

  // Future<void> updateButtonClicked() async {
  //   final todoSample = widget.todo;
  //   if (todoSample == null) {
  //     print("you cant update without totdo data");
  //     return;
  //   }
  //   final id = todoSample["_id"];
  //   final titleController = titleEditingController.text;
  //   final descriptiontController = descriptiontEditingController.text;
  //   final bodyAsJson = {
  //     "title": titleController,
  //     "description": descriptiontController,
  //     "is_completed": false
  //   };
  //   final response = await http.put(
  //     Uri.parse("https://api.nstack.in/v1/todos/$id"),
  //     body: jsonEncode(bodyAsJson),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //   if (response.statusCode == 200) {
  //     widget.onTap!();
  //     Navigator.of(context).pop();
  //     log(response.body);
  //   } else {
  //     log(response.body);
  //   }
  // }
}
