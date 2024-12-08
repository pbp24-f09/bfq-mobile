import 'dart:convert';
import 'package:bfq/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bfq/widgets/left_drawer.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
  
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> _changePassword() async {
    final request = context.read<CookieRequest>();
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final response = await request.postJson(
        "http://127.0.0.1:8000/change-password-flutter/",
        jsonEncode(<String, String>{
          "old_password": _currentPasswordController.text,
          "new_password": _newPasswordController.text,
          "confirm_password": _confirmNewPasswordController.text,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"] ?? 'Failed to change password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const LeftDrawer(),
      backgroundColor: Theme.of(context).colorScheme.primary, // Dark green background
      appBar: CustomLogoAppBar(
        scaffoldKey: _scaffoldKey,
        elevation: 6.0,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EAD8), // Beige background
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary, // Brownish-yellow
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Password:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7A6C5D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _currentPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "New Password:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7A6C5D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Confirm New Password:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7A6C5D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmNewPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB48125), // Brownish-yellow
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _changePassword,
                        child: const Text(
                          "Change Password",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
