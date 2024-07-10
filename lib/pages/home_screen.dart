// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/main.dart';
import 'package:todo_riverpod/provider/todo_state_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  late TextEditingController titleController;
  late TextEditingController descripController;

  @override
  void initState() {
    super.initState();
    ref.read(todoStateNotifierProvider.notifier).fetchTodos();
    titleController = TextEditingController();
    descripController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descripController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoStateNotifierProvider);
    final todoNotifier = ref.read(todoStateNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Color(0xff121212),
      appBar: AppBar(
        title: Text('UP ToDo',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xff121212),
        toolbarHeight: 80,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: "Enter title",
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xff979797),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descripController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: "Enter Description",
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xff979797),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          descripController.text.isNotEmpty) {
                        try {
                          todoNotifier.add(ToDo(
                            id: 0,
                            title: titleController.text,
                            description: descripController.text,
                            isCompleted: false,
                          ));
                          titleController.clear();
                          descripController.clear();
                        } catch (e) {
                          print(e.toString());
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Add TODO",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        todoNotifier.removeAll();
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff8687E7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Remove All",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: todos.isEmpty
                    ? const Center(child: Text('No Todos'))
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ListView.builder(
                          itemCount: todos.length,
                          itemBuilder: (context, index) {
                            final todo = todos[index];
                            return Dismissible(
                              key: Key(todo.id.toString()),
                              onDismissed: (direction) {
                                todoNotifier.remove(todo.id);
                              },
                              background: Container(
                                color: Color(0xff8687E7),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              child: Card(
                                elevation: 2,
                                color: Color(0xff979797),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: ListTile(
                                  title: Text(todo.title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    todo.description,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      todoNotifier.remove(todo.id);
                                    },
                                    icon: Icon(Icons.remove_circle_outline),
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
