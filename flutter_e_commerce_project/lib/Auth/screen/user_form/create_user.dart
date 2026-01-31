import 'package:flutter/material.dart';
import 'package:e_commerce/Auth/service/auth_service.dart';
import 'package:e_commerce/Auth/model/user.dart';

class CreateUser extends StatefulWidget {
  final String adminEmail;
  const CreateUser({super.key, required this.adminEmail});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String role = 'USER';
  bool isLoading = false;

  final List<String> roles = ['USER', 'ADMIN'];

  Future<void> createUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final newUser = await authService.register(
        usernameController.text,
        emailController.text,
        passwordController.text,
        role: role,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ${newUser?.username} created!')),
      );

      Navigator.pop(context, newUser);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create user: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter username' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val == null || !val.contains('@')
                    ? 'Enter valid email'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) => val == null || val.length < 6
                    ? 'Password min 6 chars'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: roles
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (val) => setState(() => role = val!),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: createUser,
                      child: const Text('Create User'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
