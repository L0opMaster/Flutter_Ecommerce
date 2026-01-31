import 'dart:convert';
import 'package:e_commerce/Auth/model/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final String baseUrl = 'http://10.0.2.2:8080'; // Your Spring Boot URL

  // Login user
  Future<User?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(response.body);
    } else {
      // Return null or throw exception with error message from backend
      final error = jsonDecode(response.body)['error'];
      throw Exception(error ?? 'Failed to login');
    }
  }

  // Register new user
  Future<User?> register(String username, String email, String password,
      {String role = 'USER'}) async {
    final url = Uri.parse('$baseUrl/users/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'role': role, // allow admin creation if needed
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(response.body);
    } else {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error ?? 'Failed to register');
    }
  }

  // Get all users (Admin only)
  Future<ListUserModel> getAllUsers(String adminEmail) async {
    final url = Uri.parse('$baseUrl/users/all?email=$adminEmail');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ListUserModel.fromJson(response.body);
    } else {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error ?? 'Failed to fetch users');
    }
  }

  // Delete user by ID (Admin only)
  Future<void> deleteUser(int id, String adminEmail) async {
    final url = Uri.parse('$baseUrl/users/$id?email=$adminEmail');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error ?? 'Failed to delete user');
    }
  }

  Future<User?> updateUser(
      {required int id,
      required String adminEmail,
      String? username,
      String? email,
      String? password,
      String? role}) async {
    final url = Uri.parse('$baseUrl/users/update/$id?email=$adminEmail');
    final Map<String, dynamic> body = {};
    if (username != null) body['username'] = username;
    if (email != null) body['email'] = email;
    if (password != null) body['password'] = password;
    if (role != null) body['role'] = role;
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return User.fromJson(response.body);
    } else {
      final error = jsonDecode(response.body)['error'];
      throw Exception(error ?? 'Failed to update user');
    }
  }
}
