import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_riverpod/pages/home_screen.dart';
import 'package:todo_riverpod/provider/todo_state_notifier.dart';
import 'package:todo_riverpod/services/dio_client.dart';
import 'package:todo_riverpod/services/todo_services.dart';

final dio = Dio();
final dioClient = DioClient(dio);

final todoStateNotifierProvider =
    StateNotifierProvider<ToDoNotifier, List<ToDo>>(
        (ref) => ToDoNotifier(TodoServices(dioClient.dio)));

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
