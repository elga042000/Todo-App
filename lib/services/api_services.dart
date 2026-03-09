import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "https://todo-auth-57585-default-rtdb.firebaseio.com";

  Future getTodos(String uid) async {
    final url = Uri.parse("$baseUrl/todos/$uid.json");

    final response = await http.get(url);

    return json.decode(response.body);
  }

  Future createTodo(String uid, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/todos/$uid.json");
    await http.post(url, body: json.encode(data));
  }

  Future updateTodo(String uid, String id, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/todos/$uid/$id.json");
    await http.patch(url, body: json.encode(data));
  }

  Future deleteTodo(String uid, String id) async {
    final url = Uri.parse("$baseUrl/todos/$uid/$id.json");

    await http.delete(url);
  }
}
