import 'package:flutter/material.dart';
import 'dart:async'; // For delay

import 'menu.dart'; // Replace with the page you want to navigate to

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay untuk berpindah ke halaman berikutnya
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MenuPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF172810),
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 150,
          height: 100,
        ),
      ),
    );
  }
}