import 'package:flutter/material.dart';
import 'dart:async'; // For delay

import 'menu.dart'; // Replace with the page you want to navigate to

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for a few seconds before navigating to the main screen
    Timer(
      const Duration(seconds: 3), // Splash screen duration
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MenuPage()), // Replace MenuPage with your home page
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4332), // Match your app's theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your app logo or an image
            Image.asset(
              'assets/images/logo.png', // Replace with your logo path
              width: 150, // Set the desired width
              height: 100, // Set the desired height
            ),
          ],
        ),
      ),
    );
  }
}
