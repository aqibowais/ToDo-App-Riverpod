// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_riverpod/Provider/todo_state_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descripController = TextEditingController();

    final todoState = ref.watch(todoStateNotifier);
    final todoNotifier = ref.read(todoStateNotifier.notifier);
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: "Enter title"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: descripController,
                  decoration: InputDecoration(hintText: "Enter Description"),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (titleController.text.isNotEmpty &&
                              descripController.text.isNotEmpty) {
                            try {
                              todoNotifier.add(ToDo(
                                title: titleController.text,
                                description: descripController.text,
                                isCompleted: false,
                              ));
                            } catch (e) {
                              print(e.toString());
                            }
                          }
                        },
                        child: Text("Add TODO")),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          try {
                            todoNotifier.removeAll();
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        child: Text("Remove All")),
                  ],
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: todoState.isEmpty
                ? const Center(child: Text('No Todos'))
                : Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                        itemCount: todoState.length,
                        itemBuilder: (context, index) {
                          final todo = todoState[index];
                          return ListTile(
                              title: Text(todo.title),
                              subtitle: Text(todo.description),
                              trailing: IconButton(
                                  onPressed: () {
                                    todoNotifier.remove(todo.title);
                                  },
                                  icon: Icon(Icons.remove_circle_outline)));
                        }),
                  ),
          ),
        ]),
      ),
    ));
  }
}
