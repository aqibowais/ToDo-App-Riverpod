// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:todo_riverpod/model/model.dart';

class TodoServices {
  final Dio _dio;

  TodoServices(this._dio);

  Future<List<TodoModel>> fetchTodos() async {
    try {
      final response = await _dio.get("/todos");
      final data = response.data as List;
      print(data.map((todo) => TodoModel.fromJson(todo)).toList());
      return data.map((todo) => TodoModel.fromJson(todo)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
      rethrow;
    }
  }

  Future<void> postTodo(
      String? title, String? description, bool? isCompleted) async {
    try {
      final response = await _dio.post(
        "/todos",
        data: {
          'title': title,
          'description': description,
          'isCompleted': isCompleted,
        },
      );
      print(response);
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
      rethrow;
    }
  }

  Future<void> deleteTodoById(int id) async {
    await _dio.delete("/todos/$id");
  }

  Future<void> deleteAllTodos(List<int> ids) async {
    for (var id in ids) {
      await deleteTodoById(id);
    }
  }
}
