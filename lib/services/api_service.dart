import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_dto.dart';

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:8080/todo_api';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<List<Task>> fetchTasks() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/tasks.php'), headers: _headers)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      if (body['success'] == true) {
        final List<dynamic> data = body['data'];
        return data.map((json) => Task.fromJson(json)).toList();
      }
      throw Exception(body['message'] ?? 'Failed to load tasks');
    }
    throw Exception('Server error: ${response.statusCode}');
  }

  Future<Task> createTask(String title) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/tasks.php'),
          headers: _headers,
          body: json.encode({'title': title}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      if (body['success'] == true) {
        return Task.fromJson(body['data']);
      }
      throw Exception(body['message'] ?? 'Failed to create task');
    }
    throw Exception('Server error: ${response.statusCode}');
  }

  Future<Task> updateTaskTitle(int id, String title) async {
    final response = await http
        .put(
          Uri.parse('$_baseUrl/tasks.php'),
          headers: _headers,
          body: json.encode({'id': id, 'title': title}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      if (body['success'] == true) {
        return Task.fromJson(body['data']);
      }
      throw Exception(body['message'] ?? 'Failed to update task');
    }
    throw Exception('Server error: ${response.statusCode}');
  }

  Future<Task> toggleTaskStatus(int id, bool isCompleted) async {
    final response = await http
        .patch(
          Uri.parse('$_baseUrl/tasks.php'),
          headers: _headers,
          body: json.encode({'id': id, 'done': isCompleted ? 1 : 0}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      if (body['success'] == true) {
        return Task.fromJson(body['data']);
      }
      throw Exception(body['message'] ?? 'Failed to toggle status');
    }
    throw Exception('Server error: ${response.statusCode}');
  }

  Future<void> deleteTask(int id) async {
    final response = await http
        .delete(
          Uri.parse('$_baseUrl/tasks.php'),
          headers: _headers,
          body: json.encode({'id': id}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      if (body['success'] == true) return;
      throw Exception(body['message'] ?? 'Failed to delete task');
    }
    throw Exception('Server error: ${response.statusCode}');
  }
}
