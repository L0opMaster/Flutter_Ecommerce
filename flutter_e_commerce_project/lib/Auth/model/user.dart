// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final String role; // 'USER' or 'ADMIN'

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      role: map['role'] as String? ?? 'USER',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, password: $password, role: $role)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.username == username &&
        other.email == email &&
        other.password == password &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        password.hashCode ^
        role.hashCode;
  }
}

class ListUserModel {
  final List<User> users;

  ListUserModel({
    required this.users,
  });

  ListUserModel copyWith({
    List<User>? users,
  }) {
    return ListUserModel(
      users: users ?? this.users,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'users': users.map((x) => x.toMap()).toList(),
    };
  }

  factory ListUserModel.fromMap(Map<String, dynamic> map) {
    return ListUserModel(
      users: List<User>.from(
        (map['users'] as List<dynamic>).map<User>(
          (x) => User.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListUserModel.fromJson(String source) {
    try {
      final List<dynamic> jsonList = jsonDecode(source) as List<dynamic>;
      return ListUserModel(
          users: jsonList.map((json) => User.fromMap(json)).toList());
    } catch (e) {
      throw FormatException("Invalid JSON format: $e");
    }
  }

  @override
  String toString() => 'ListUserModel(users: $users)';

  @override
  bool operator ==(covariant ListUserModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.users, users);
  }

  @override
  int get hashCode => users.hashCode;
}
