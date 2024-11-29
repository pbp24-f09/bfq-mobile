import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bfq/authentication/screens/register.dart';
import 'package:bfq/main/screens/menu_customer.dart';
import 'package:bfq/main/screens/menu_admin.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _usernameError; // Variabel untuk pesan kesalahan username
  String? _passwordError; // Variabel untuk pesan kesalahan password

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 75,
              height: 50,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 6,
      ),
      body: Stack(
        children: [
          // Gambar sebagai background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/register.png'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Warna hitam semi-transparan
          ),
          // Konten login
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Theme.of(context).colorScheme.onBackground,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                            hintText: 'Enter your username',
                            hintStyle: const TextStyle(
                            color: Colors.grey,
                            ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          errorText: _usernameError,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
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

                          // Kirim permintaan login
                          final response = await request.login(
                            "http://127.0.0.1:8000/login-flutter/",
                            {
                              'username': username,
                              'password': password,
                            },
                          );

                          if (request.loggedIn) {
                            // Jika login berhasil
                            if (response.containsKey('role') &&
                                response.containsKey('message')) {
                              String role = response['role'];
                              String message = response['message'];
                              String uname = response['username'];

                              if (context.mounted) {
                                // Redirect ke halaman berdasarkan role
                                if (role == 'customer') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MenuCustomerPage()),
                                  );
                                } else if (role == 'admin') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MenuAdminPage()),
                                  );
                                }

                                // Tampilkan snackbar sukses
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("$message Welcome, $uname."),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          } else {
                            // Jika login gagal, tampilkan pesan error
                            setState(() {
                              _usernameError = null; // Reset error username
                              _passwordError = response['message'] ??
                                  'Invalid username or password.';
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
                      const SizedBox(height: 24.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondary, // Warna teks default
                              fontSize: 16.0,
                            ),
                            children: [
                              TextSpan(
                                text: 'Register here',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary, // Warna "Register here"
                                  fontWeight: FontWeight.bold, // Gaya teks tebal
                                  decoration: TextDecoration.underline, // Garis bawah
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}