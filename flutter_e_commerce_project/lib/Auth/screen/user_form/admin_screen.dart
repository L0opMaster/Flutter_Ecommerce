import 'package:e_commerce/Auth/screen/auth_login_signout.dart/auth_screen.dart';
import 'package:e_commerce/Auth/screen/product_form/product_panel.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/Auth/service/auth_service.dart';
import 'package:e_commerce/Auth/screen/user_form/create_user.dart';
import 'package:e_commerce/Auth/screen/user_form/update_user.dart';
import 'package:e_commerce/Auth/screen/auth_login_signout.dart/auth_form.dart';
import 'package:e_commerce/Auth/model/user.dart';

class AdminScreen extends StatefulWidget {
  final String adminEmail; // Pass logged-in admin email
  const AdminScreen({super.key, required this.adminEmail});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<User> users = [];
  bool isLoading = true;
  User? selectedUser;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Fetch all users (admin only)
  Future<void> fetchUsers() async {
    setState(() => isLoading = true);
    try {
      final listUserModel = await authService.getAllUsers(widget.adminEmail);
      setState(() {
        users = listUserModel.users;
        selectedUser = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Logout admin
  Future<void> logout() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthForm()),
      (route) => false,
    );
  }

  // Confirm delete user dialog
  void _confirmDelete(User user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.username}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // Cancel
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close dialog
              try {
                await authService.deleteUser(user.id, widget.adminEmail);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${user.username} deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                fetchUsers(); // Refresh list after deletion
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete user: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              icon: const Icon(Icons.exit_to_app_outlined)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Action buttons
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Create User
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(fixedSize: Size(90, 0)),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreateUser(adminEmail: widget.adminEmail),
                          ),
                        );
                        fetchUsers();
                      },
                      child: const Text('Create'),
                    ),
                    const SizedBox(width: 10),

                    // Update User
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(fixedSize: Size(100, 0)),
                      onPressed: selectedUser == null
                          ? null
                          : () async {
                              final updatedUser = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateUser(
                                    user: selectedUser!,
                                    adminEmail: widget.adminEmail,
                                  ),
                                ),
                              );
                              if (updatedUser != null) fetchUsers();
                            },
                      child: const Text('Update'),
                    ),
                    const SizedBox(width: 10),

                    // Delete User
                    ElevatedButton(
                      onPressed: selectedUser == null
                          ? null
                          : () => _confirmDelete(selectedUser!),
                      child: const Text('Delete'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductPanel(
                                      adminEmail: widget.adminEmail,
                                    )));
                      },
                      child: const Text('Product'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // User Table
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : users.isEmpty
                      ? const Center(child: Text('No users found'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Username')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Role')),
                            ],
                            rows: users
                                .map(
                                  (user) => DataRow(
                                    selected: selectedUser?.id == user.id,
                                    onSelectChanged: (selected) {
                                      setState(() {
                                        selectedUser = selected! ? user : null;
                                      });
                                    },
                                    cells: [
                                      DataCell(Text(user.id.toString())),
                                      DataCell(Text(user.username)),
                                      DataCell(Text(user.email)),
                                      DataCell(Text(user.role)),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
