import 'package:flutter/material.dart';
import 'package:bfq/screens/main/menu.dart';
import 'package:bfq/screens/authentication/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Test',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Derovana', // Gunakan font global
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch:const MaterialColor(
              0xFF2A3A30,
              const {
                50: Color(0xFFE4E6E5),
                100: Color(0xFFBCC0BF),
                200: Color(0xFF919793),
                300: Color(0xFF666D68),
                400: Color(0xFF454D48),
                500: Color(0xFF2A3A30),
                600: Color(0xFF24332B),
                700: Color(0xFF1C2A24),
                800: Color(0xFF15201C),
                900: Color(0xFF0B120F),
              },
            ),
          ).copyWith(
            primary: const Color(0xFF2A3A30), // Hijau tua
            secondary: const Color(0xFFB48125), // Kuning coklat
            surface: const Color(0xFF254832), // Hijau sedang
            background: const Color(0xFF325D41), // Hijau terang
            error: const Color(0xFF994E12), // Coklat gelap
            onPrimary: Colors.white, // Teks pada elemen primer
            onSecondary: Colors.black, // Teks pada elemen sekunder
            onSurface: Colors.black, // Teks pada elemen permukaan
            onBackground: Colors.white, // Teks pada latar belakang
          ),
        ),
        home: const MenuPage(),
      ),
    );
  }
}
