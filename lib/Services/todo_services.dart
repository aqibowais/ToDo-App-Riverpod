// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:todo_riverpod/Model/model.dart';
import 'package:todo_riverpod/Provider/todo_state_notifier.dart';
import 'package:todo_riverpod/constants/env.dart';

class TodoServices {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: todoApi, responseType: ResponseType.json));
  Future<List<TodoModel>> fetchTodos() async {
    try {
      final response = await _dio.get("/todos");
      final data = response.data as List;
      print(data.map((todo) => TodoModel.fromJson(todo)).toList());
      return data.map((todo) => TodoModel.fromJson(todo)).toList();
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
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

  Future<void> deleteTodoByTitle(ToDo title) async {
    await _dio.delete("/todos/$title");
  }

  Future<void> deleteAllTodos() async {
    await _dio.delete("/todos");
  }
}
