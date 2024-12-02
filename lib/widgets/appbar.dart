import 'package:flutter/material.dart';

class CustomLogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final double elevation;
  final GlobalKey<ScaffoldState> scaffoldKey; // Tambahkan scaffold key untuk mengontrol Drawer

  const CustomLogoAppBar({
    super.key,
    this.backgroundColor = const Color(0xFF172810), // Warna default AppBar
    this.elevation = 6.0, // Elevasi default
    required this.scaffoldKey, // Key wajib diisi
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu), // Ikon menu untuk membuka drawer
        onPressed: () {
          scaffoldKey.currentState?.openDrawer(); // Membuka Drawer
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 75,
            height: 50,
            fit: BoxFit.contain,
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.white, // Warna ikon menu
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}