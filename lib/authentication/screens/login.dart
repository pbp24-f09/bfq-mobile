import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bfq/authentication/screens/register.dart';
import 'package:bfq/main/screens/menu_customer.dart';
import 'package:bfq/main/screens/menu_admin.dart';
import 'package:bfq/authentication/widgets/auth_layout.dart';
import 'package:bfq/authentication/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _usernameError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final userProvider = context.read<UserProvider>();

    return AuthLayout(
      title: 'Login',
      backgroundImage: 'assets/images/register.png',
      formContent: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your username',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              errorText: _usernameError,
            ),
          ),
          const SizedBox(height: 12.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              errorText: _passwordError,
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () async {
              String username = _usernameController.text.trim();
              String password = _passwordController.text.trim();

              setState(() {
                _usernameError = null;
                _passwordError = null;
              });

              if (username.isEmpty) {
                setState(() {
                  _usernameError = 'Please enter your username';
                });
              }
              if (password.isEmpty) {
                setState(() {
                  _passwordError = 'Please enter your password';
                });
              }
              if (_usernameError != null || _passwordError != null) {
                return;
              }

              final response = await request.login(
                "http://127.0.0.1:8000/login-flutter/",
                {
                  'username': username,
                  'password': password,
                },
              );

              if (request.loggedIn) {
                if (response.containsKey('role') &&
                    response.containsKey('username')) {
                  String role = response['role'];
                  String uname = response['username'];

                  // Update UserProvider dengan data user dari API
                  userProvider.updateUser(
                    fullName: response['full_name'] ?? '',
                    email: response['email'] ?? '',
                    profilePhoto: response['profile_photo'] ?? '',
                    username: uname,
                    age: response['age'] ?? 0,
                    gender: response['gender'] ?? '',
                    phoneNumber: response['phone_number'] ?? '',
                    role: role,
                  );

                  if (context.mounted) {
                    if (role == 'customer') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuCustomerPage(),
                        ),
                      );
                    } else if (role == 'admin') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuAdminPage(),
                        ),
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Welcome, $uname."),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Login successful but user data is missing."),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              } else {
                setState(() {
                  _passwordError = 'Invalid username or password.';
                });
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.error,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text('Login'),
          ),
        ],
      ),
      footer: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterPage(),
            ),
          );
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 16.0,
            ),
            children: [
              TextSpan(
                text: 'Register here',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}