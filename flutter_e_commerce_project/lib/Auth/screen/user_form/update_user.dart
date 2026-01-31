import 'package:flutter/material.dart';
import 'package:e_commerce/Auth/service/auth_service.dart';
import 'package:e_commerce/Auth/model/user.dart';

class UpdateUser extends StatefulWidget {
  final User user;
  final String adminEmail;

  const UpdateUser({super.key, required this.user, required this.adminEmail});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  String role = 'USER';
  bool isLoading = false;

  final List<String> roles = ['USER', 'ADMIN'];

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user.username);
    emailController = TextEditingController(text: widget.user.email);
    passwordController = TextEditingController(text: widget.user.password);
    role = widget.user.role;
  }

  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final updatedUser = await authService.updateUser(
        id: widget.user.id,
        adminEmail: widget.adminEmail,
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        role: role,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ${updatedUser?.username} updated!')),
      );
      Navigator.pop(context, updatedUser);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update User')),
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
                validator: (val) =>
                    val == null || !val.contains('@') ? 'Enter valid email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) =>
                    val == null || val.length < 6 ? 'Password min 6 chars' : null,
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
                      onPressed: updateUser,
                      child: const Text('Update User'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
