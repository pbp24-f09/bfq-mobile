import 'package:flutter/material.dart';
import 'package:bfq/main/screens/splash_screen.dart';
import 'package:bfq/authentication/screens/login.dart';
import 'package:bfq/blog/screens/blog_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bfq/authentication/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        title: 'BFQ',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: const MaterialColor(
              0xFF172810,
              {
                50: Color(0xFFE4E9E2),
                100: Color(0xFFBCCEBA),
                200: Color(0xFF91B292),
                300: Color(0xFF66966A),
                400: Color(0xFF4A7F4D),
                500: Color(0xFF306836),
                600: Color(0xFF2A5E30),
                700: Color(0xFF234E27),
                800: Color(0xFF1C3E1F),
                900: Color(0xFF122914),
              },
            ),
          ).copyWith(
            primary: const Color(0xFF172810), // Hijau tua
            secondary: const Color(0xFFB48125), // Kuning coklat
            surface: const Color(0xFF102820), // Hijau terang
            error: const Color.fromARGB(255, 131, 87, 51), // Coklat gelap
            onPrimary: Colors.white, // Teks pada elemen primer
            onSecondary: Colors.black, // Teks pada elemen sekunder
            onSurface: Colors.black,
            onBackground: const Color.fromARGB(193, 255, 255, 255), // Teks pada elemen permukaan
          ),
        ),
        // Atur SplashScreen langsung sebagai `home`
        home: SplashScreen(),
      ),
    );
  }
}