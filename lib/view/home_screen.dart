import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:to_do_app/view/add_todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List items = [];
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("TODO"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addScreen();
        },
        child: Text("Add"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (ctx, index) {
            final data = items[index] as Map;
            // final id = data[] as String;
            return ListTile(
              leading: Text('${index + 1}'),
              title: Text(
                data["title"],
              ),
              subtitle: Text(
                data["description"],
              ),
            );
          },
        ),
      ),
    );
  }

  void addScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return AddTodo();
        },
      ),
    );
  }

  void fetchData() async {
    final response = await http.get(
        Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=20"),
        headers: {"accpet": "application/json"});
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      setState(
        () {
          items = result;
        },
      );
      log(items.toString());
    } else {
      //show error
    }
  }
}
