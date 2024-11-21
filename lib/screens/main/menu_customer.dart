import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'menu.dart';
import 'package:bfq/widgets/left_drawer.dart';

class MenuCustomerPage extends StatelessWidget {
  const MenuCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final response = await request.logout("http://127.0.0.1:8000/logout-flutter/");
              String message = response["message"];
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$message Logout berhasil.")),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuPage()),
                );
              }
            },
          ),
        ],
      ),

      drawer: const LeftDrawer(),

      body: const Center(
        child: Text('Welcome, Customer!'),
      ),
    );
  }
}
