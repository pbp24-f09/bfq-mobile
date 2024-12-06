import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Pastikan CookieRequest digunakan dengan benar
import 'dart:convert';
import 'package:bfq/widgets/left_drawer.dart';
import 'package:bfq/widgets/appbar.dart';


class UserProfileEditPage extends StatefulWidget {
  const UserProfileEditPage({Key? key}) : super(key: key);

  @override
  _UserProfileEditPageState createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  // Controller untuk TextFormField
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  
  bool isLoading = true;  // Status loading
  String? errorMessage;  // Untuk menampilkan error jika ada masalah
  Map<String, dynamic>? profileData;  // Data profil yang diterima dari API
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();  // Memanggil fungsi fetch data profil saat halaman dimuat
  }

  Future<void> _fetchUserProfile() async {
    try {
      final request = context.read<CookieRequest>();  // Mendapatkan instance CookieRequest
      final response = await request.get('http://127.0.0.1:8000/profile-flutter/');  // Meminta data profil dari API

      // Cek jika data yang diterima valid
      if (response.containsKey('full_name') &&
          response.containsKey('email')) {
        setState(() {
          profileData = response;  // Menyimpan data profil di variable profileData
          isLoading = false;  // Set loading menjadi false setelah data berhasil didapatkan
        });

        // Isi form dengan data yang diterima dari API
        _fullNameController.text = response['full_name'];
        _emailController.text = response['email'];
        _ageController.text = response['age']?.toString() ?? '';
        _genderController.text = response['gender'] ?? '';
        _phoneNumberController.text = response['phone_number'] ?? '';
      } else {
        setState(() {
          errorMessage = "Invalid profile data received.";  // Pesan error jika data tidak valid
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load profile.";  // Pesan error jika gagal mengambil data
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.primary,
      drawer: const LeftDrawer(),
      appBar: CustomLogoAppBar(
        scaffoldKey: _scaffoldKey,
        elevation: 6.0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())  // Tampilkan loading indicator saat data sedang diambil
          : errorMessage != null
              ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))  // Tampilkan pesan error jika ada
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form fields untuk mengedit data profil
                        TextFormField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(labelText: 'Full Name'),
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(labelText: 'Age'),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: _genderController,
                          decoration: const InputDecoration(labelText: 'Gender'),
                        ),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: const InputDecoration(labelText: 'Phone Number'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            // Kirim data yang sudah diubah oleh user ke API
                            final request = context.read<CookieRequest>();
                            final response = await request.postJson(
                              "http://127.0.0.1:8000/update-profile-flutter/",
                              jsonEncode(<String, String>{
                                'full_name': _fullNameController.text,
                                'email': _emailController.text,
                                'age': _ageController.text,
                                'gender': _genderController.text,
                                'phone_number': _phoneNumberController.text,
                              }),
                            );

                            if (response['status'] == 'success') {
                              // Tampilkan pesan sukses jika profil berhasil diperbarui
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Profile updated successfully")),
                              );
                              Navigator.pop(context);  // Kembali ke halaman sebelumnya setelah berhasil update
                            } else {
                              // Tampilkan pesan error jika gagal memperbarui profil
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Failed to update profile")),
                              );
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
