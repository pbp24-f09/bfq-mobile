import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final String title; // Judul di dalam card (e.g., "Login" atau "Register")
  final Widget formContent; // Konten form di dalam card
  final Widget footer; // Footer seperti "Already have an account?" atau "Don't have an account?"
  final String backgroundImage; // Gambar untuk background

  const AuthLayout({
    super.key,
    required this.title,
    required this.formContent,
    required this.footer,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
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
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Shadow Overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      formContent, // Form content passed as parameter
                      const SizedBox(height: 24.0),
                      footer, // Footer passed as parameter
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