import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '/screens/authentication/login.dart';
import '/screens/authentication/register.dart'; // Tambahkan impor untuk halaman register

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isLoggedIn = request.loggedIn; // Status login pengguna

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text(
              'Welcome to the App!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),

          // Jika belum login, tampilkan opsi login dan register
          if (!isLoggedIn) ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('Register'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
            ),
          ],

        ],
      ),
    );
  }
}
