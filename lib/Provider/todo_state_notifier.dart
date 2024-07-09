import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/Services/todo_services.dart';

@immutable
class ToDo {
  final String title;
  final String description;
  final bool isCompleted;
  const ToDo(
      {required this.title,
      required this.description,
      required this.isCompleted});

  ToDo copyWith(String? title, String? description, bool? isCompleted) {
    return ToDo(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class ToDoNotifier extends StateNotifier<List<ToDo>> {
  final TodoServices _todoServices;
  ToDoNotifier(this._todoServices) : super([]) {
    fetchTodos();
  }
  Future<void> fetchTodos() async {
    try {
      final todos = await _todoServices.fetchTodos();
      state = todos
          .map((todo) => ToDo(
                title: todo.title ?? '',
                description: todo.description ?? '',
                isCompleted: false,
              ))
          .toList();
    } catch (e) {
      print('Failed to add todo: $e');
    }
  }

  Future<void> add(ToDo todo) async {
    try {
      await _todoServices.postTodo(
          todo.title, todo.description, todo.isCompleted);
      state = [...state, todo];
    } catch (e) {
      print('Failed to add todo: $e');
    }
  }

  Future<void> remove(String todoTitle) async {
    try {
      final todoToRemove = state.firstWhere((todo) => todo.title == todoTitle);
      await _todoServices.deleteTodoByTitle(todoToRemove);
      state = state.where((element) => element.title != todoTitle).toList();
    } catch (e) {
      print('Failed to remove todo: $e');
    }
  }

  Future<void> removeAll() async {
    try {
      await _todoServices.deleteAllTodos();
      state = [];
    } catch (e) {
      print('Failed to remove all todos: $e');
    }
  }
}

final todoStateNotifier = StateNotifierProvider<ToDoNotifier, List<ToDo>>(
    (ref) => ToDoNotifier(TodoServices()));
