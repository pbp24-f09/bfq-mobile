import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'user_profile.dart';
import 'package:bfq/authentication/user_provider.dart';

class UserProfileEditPage extends StatefulWidget {
  const UserProfileEditPage({Key? key}) : super(key: key);

  @override
  _UserProfileEditPageState createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final request = context.read<CookieRequest>();
      final response =
          await request.get('http://127.0.0.1:8000/profile-flutter/');

      if (response.containsKey('full_name') && response.containsKey('email')) {
        setState(() {
          profileData = response;
          isLoading = false;
        });

        _fullNameController.text = response['full_name'];
        _emailController.text = response['email'];
        _ageController.text = response['age']?.toString() ?? '';
        _genderController.text = response['gender'] ?? '';
        _phoneNumberController.text = response['phone_number'] ?? '';
      } else {
        setState(() {
          errorMessage = "Invalid profile data received.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load profile. Please try again later.";
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
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
        context.read<UserProvider>().updateUser(
              fullName: _fullNameController.text,
              email: _emailController.text,
              age: int.tryParse(_ageController.text) ?? 0,
              gender: _genderController.text,
              phoneNumber: _phoneNumberController.text,
              profilePhoto: profileData?['profile_photo'] ?? '',
              username: profileData?['username'] ?? '',
              role: profileData?['role'] ?? '',
            );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserProfilePage()),
        );
      } else {
        throw Exception(response['message'] ?? "Failed to update profile");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1c3714), // Dark green background
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
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserProfilePage()),
            );
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EAD8), // Beige background
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB48125), // Brownish-yellow
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFormField("Full Name", _fullNameController),
                          const SizedBox(height: 12),
                          _buildFormField("Email", _emailController),
                          const SizedBox(height: 12),
                          _buildFormField("Age", _ageController, isNumeric: true),
                          const SizedBox(height: 12),
                          _buildFormField("Gender", _genderController),
                          const SizedBox(height: 12),
                          _buildFormField("Phone Number", _phoneNumberController,
                              isNumeric: true),
                          const SizedBox(height: 24),
                          Center(
                            child: ElevatedButton(
                              onPressed: _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB48125), // Brownish-yellow
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Save",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF7A6C5D),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}