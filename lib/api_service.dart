import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'task_model.dart';

class ApiService {
  static const String baseUrl = 'https://68684585d5933161d70b3ecc.mockapi.io';

  // ===== Usuarios =====
  static Future<List<UserModel>> getUsers() async {
    final res = await http.get(Uri.parse('$baseUrl/users'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> postUser(UserModel user) async {
    await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
  }

  // ===== Tareas =====
  static Future<List<TaskModel>> getTasks(String userId) async {
    final res = await http.get(Uri.parse('$baseUrl/tareas?userId=$userId'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => TaskModel.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> postTask(TaskModel task) async {
    await http.post(
      Uri.parse('$baseUrl/tareas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
  }

  static Future<void> putTask(TaskModel task) async {
    await http.put(
      Uri.parse('$baseUrl/tareas/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
  }

  static Future<void> deleteTask(String id) async {
    await http.delete(Uri.parse('$baseUrl/tareas/$id'));
  }
}
