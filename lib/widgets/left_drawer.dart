import 'package:bfq/blog/screens/blog_list.dart';
import 'package:flutter/material.dart';
import 'package:bfq/main/screens/menu.dart';
import 'package:bfq/main/screens/menu_admin.dart';
import 'package:bfq/main/screens/menu_customer.dart';
import 'package:bfq/categories/screens/categories_admin.dart';
import 'package:bfq/categories/screens/categories_customer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bfq/authentication/screens/login.dart';
import 'package:bfq/authentication/screens/user_profile.dart';
import 'package:bfq/authentication/user_provider.dart';
import 'package:bfq/authentication/screens/change_password.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final userProvider = context.watch<UserProvider>(); // Ambil data dari UserProvider
    final bool isLoggedIn = request.loggedIn; // Cek apakah user sudah login

    return Drawer(
      backgroundColor: const Color(0xFFF3EAD8), // Warna latar Drawer
      child: Column(
        children: [
          // Wrapper untuk mengatasi overflow
          SingleChildScrollView(
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40, // Ukuran foto profil
                    backgroundImage: userProvider.profilePhoto.isNotEmpty
                        ? NetworkImage(userProvider.profilePhoto)
                        : const AssetImage('assets/images/default-profile.jpg')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      isLoggedIn
                          ? userProvider.fullName
                          : 'User Not Detected',
                      overflow: TextOverflow.ellipsis, // Potong teks jika terlalu panjang
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      isLoggedIn ? userProvider.username : 'Guest',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Home'),
                  onTap: () {
                    if (userProvider.role == 'admin') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuAdminPage(),
                        ),
                      );
                    } else if (userProvider.role == 'customer') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuCustomerPage(),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuPage(),
                        ),
                      );
                    }
                  },
                ),
                if (isLoggedIn) ...[
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfilePage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.article),
                    title: const Text('Blog'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BlogListPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Change Password'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Categories'),
                    onTap: () {
                      if (userProvider.role == 'admin'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoriesAdminPage(),
                          ),
                        );
                      } else if (userProvider.role == 'customer'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoriesCustomerPage(),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      final response = await request.logout(
                          "http://127.0.0.1:8000/logout-flutter/");
                      String message = response["message"];
                      if (context.mounted) {
                        if (response['status']) {
                          context.read<UserProvider>().resetUser(); // Reset data user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("$message Goodbye!"),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MenuPage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Login'),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF172810), // Warna hijau
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Gambar logo
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}