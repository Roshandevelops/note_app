import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:to_do_app/view/add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool isLoading = true;

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
        child: Visibility(
          visible: items.isNotEmpty,
          replacement: Center(
            child: Text("NO TODO ITEM"),
            // CircularProgressIndicator(),
          ),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              final item = items[index] as Map;
              final id = item["_id"] as String;

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    item["title"],
                  ),
                  subtitle: Text(
                    item["description"],
                  ),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == "edit") {
                      editScreen(item);
                      //edit item
                    } else if (value == "delete") {
                      deleteById(id);
                      //delete item
                    }
                  }, itemBuilder: (ctx) {
                    return [
                      PopupMenuItem(
                        child: Text("Edit"),
                        value: "edit",
                      ),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: "delete",
                      ),
                    ];
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> addScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return AddScreen(
            onTap: () async {
              await fetchData();
            },
          );
        },
      ),
    );
  }

  Future<void> editScreen(Map item) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return AddScreen(
            todo: item,
            onTap: () async {
              await fetchData();
            },
          );
        },
      ),
    );
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=20"),
      headers: {"accpet": "application/json"},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      setState(
        () {
          items = result;
        },
      );
      log(items.toString());
    }
  }

  Future<void> deleteById(String id) async {
    final response =
        await http.delete(Uri.parse("https://api.nstack.in/v1/todos/$id"));
    final filteredItems = items.where((e) => e["_id"] != id).toList();
    setState(() {
      items = filteredItems;
    });
    if (response.statusCode == 200) {
    } else {}
  }
}
