import 'package:flutter/material.dart';
import 'package:todoapp/services/api_services.dart';
import '../models/todo.dart';


class TodoProvider with ChangeNotifier {
  List<Todo> todos = [];
  final api = ApiService();

  Future fetchTodos(String uid) async {
    final data = await api.getTodos(uid);
    todos.clear();

    if (data != null) {
      data.forEach((key, value) {
        todos.add(Todo.fromJson(key, value));
      });
    }

    notifyListeners();
  }

  Future addTodo(String uid, String title, String details) async {
    await api.createTodo(uid, {
      "title": title,
      "details": details,
      "completed": false,
    });
    await fetchTodos(uid);
  }

  Future toggleComplete(String uid, Todo todo) async {
    await api.updateTodo(uid, todo.id, {"completed": !todo.completed});
    await fetchTodos(uid);
  }

  Future updateTodo(String uid, Todo todo) async {
    await api.updateTodo(uid, todo.id, todo.toJson());
    await fetchTodos(uid);
  }

  Future deleteTodo(String uid, String id) async {
    await api.deleteTodo(uid, id);
    await fetchTodos(uid);
  }
}