// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/services/todo_services.dart';

class ToDo {
  final String title;
  final String description;
  final bool isCompleted;
  final int id;

  ToDo({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.id,
  });

  ToDo copyWith(
      {String? title,
      String? description,
      bool? isCompleted,
      required int id}) {
    return ToDo(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      id: id,
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
                id: int.parse(todo.id ?? '0'),
              ))
          .toList();
    } catch (e) {
      print('Failed to fetch todos: $e');
    }
  }

  Future<void> add(ToDo todo) async {
    final newTodo = ToDo(
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
      id: state.isEmpty ? 0 : state.last.id + 1,
    );

    state = [...state, newTodo];
    try {
      await _todoServices.postTodo(
        newTodo.title,
        newTodo.description,
        newTodo.isCompleted,
      );
    } catch (e) {
      print('Failed to add todo: $e');
    }
  }

  Future<void> remove(int id) async {
    state = state.where((todo) => todo.id != id).toList();
    try {
      await _todoServices.deleteTodoById(id);
    } catch (e) {
      print('Failed to remove todo: $e');
    }
  }

  Future<void> removeAll() async {
    final ids = state.map((todo) => todo.id).toList();
    state = [];
    try {
      await _todoServices.deleteAllTodos(ids);
    } catch (e) {
      print('Failed to remove all todos: $e');
    }
  }
}
