import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/controller/todo_provider.dart';

import 'package:to_do_app/view/add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List items = [];
  @override
  void initState() {
    Provider.of<TodoProvider>(context, listen: false).getData();
    // fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TODO"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addScreen();
        },
        child: const Text("Add"),
      ),
      body: Consumer<TodoProvider>(builder: (context, todoprovider, child) {
        items = todoprovider.newFetchedItems;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
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
                      } else if (value == "delete") {
                        Provider.of<TodoProvider>(context, listen: false)
                            .deleteItemFromServer(id, items);
                      }
                    }, itemBuilder: (ctx) {
                      return [
                        const PopupMenuItem(
                          value: "edit",
                          child: Text("Edit"),
                        ),
                        const PopupMenuItem(
                          value: "delete",
                          child: Text("Delete"),
                        ),
                      ];
                    }),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Future<void> addScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return AddScreen(
            onTap: () async {
              await Provider.of<TodoProvider>(context, listen: false).getData();
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
              await Provider.of<TodoProvider>(context, listen: false).getData();
              log("edited".toString());
            },
          );
        },
      ),
    );
  }
}
