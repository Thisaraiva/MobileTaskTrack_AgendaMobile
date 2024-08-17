import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://192.168.0.15:5000/api';

  // Tasks CRUD Operations
  Future<http.Response> fetchTasksByUsername(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/tasks/user/$username'));
    return response;
  }

 Future<http.Response> fetchTasks({
  required String userId,
  DateTime? startDate,
  DateTime? endDate,
  String? status,
}) async {
  final queryParameters = <String, String>{};

  if (startDate != null) {
    queryParameters['startDate'] = startDate.toIso8601String();
  }

  if (endDate != null) {
    queryParameters['endDate'] = endDate.toIso8601String();
  }
  
  if (status != null) {
    queryParameters['status'] = status;
  }

  final uri = Uri.http(
    '192.168.0.15:5000',
    '/api/tasks/user/$userId/daterange',
    queryParameters,
  );

  return await http.get(uri);
}






  Future<http.Response> fetchTasksByDate(String username, String startDate, String endDate) async {
    final response = await http.get(Uri.parse('$baseUrl/tasks/user/$username/date?start=$startDate&end=$endDate'));
    return response;
  }

  Future<http.Response> fetchTasksById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/tasks/$id'));
    return response;
  }

  Future<http.Response> fetchTasksByUserId(String userId) async {
    final url = Uri.parse('$baseUrl/tasks/user/$userId');
    return await http.get(url);
  }

  Future<http.Response> fetchTasksByStatus(String userId, String status) async {
    final url = Uri.parse('$baseUrl/tasks/user/$userId/status/$status');
    return await http.get(url);
  }

  Future<http.Response> fetchTasksByDateRange(String userId, DateTimeRange dateRange) async {
    final url = Uri.parse('$baseUrl/tasks/user/$userId/daterange')
        .replace(queryParameters: {
          'startDate': dateRange.start.toIso8601String(),
          'endDate': dateRange.end.toIso8601String()
        });
    print('Fetching tasks by date range from: $url');
    return await http.get(url);
  }

  Future<http.Response> saveTask(String userId, String title, String description) async {
    final url = Uri.parse('$baseUrl/tasks');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'title': title,
        'description': description,
      }),
    );
  }

  Future<http.Response> createTask(Map<String, dynamic> taskData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(taskData),
    );
    return response;
  }

  Future<http.Response> updateTask(String id, Map<String, dynamic> taskData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(taskData),
    );
    return response;
  }

  Future<http.Response> deleteTask(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));
    return response;
  }

  // Users CRUD Operations
  Future<http.Response> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    return response;
  }

  Future<http.Response> fetchUserById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    return response;
  }

  Future<http.Response> fetchUserByEmail(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/users/email/$email'));
    return response;
  }

  Future<http.Response> createUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    return response;
  }

  Future<http.Response> updateUser(String id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    return response;
  }

  Future<http.Response> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));
    return response;
  }

  // User Authentication
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
