import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bfq/widgets/appbar.dart';
import 'package:bfq/widgets/left_drawer.dart';
import 'package:bfq/authentication/user_provider.dart';
import 'edit_profile.dart';
import 'package:bfq/main/screens/menu.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? profileData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final request = context.read<CookieRequest>();
      final response =
          await request.get('https://redundant-raychel-bfq-f4b73b50.koyeb.app/profile-flutter/');
      if (response.containsKey('username') &&
          response.containsKey('full_name') &&
          response.containsKey('email')) {
        setState(() {
          profileData = response;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Invalid profile data received.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load profile.";
        isLoading = false;
      });
    }
  }

  Widget _editPhotoModal(BuildContext context) {
    final TextEditingController _photoUrlController = TextEditingController();
    final request = context.read<CookieRequest>();
    bool isLoading = false;

    // Fetch current photo URL
    void _fetchCurrentPhoto() async {
      final response =
          await request.get('https://redundant-raychel-bfq-f4b73b50.koyeb.app/profile-flutter/');
      if (response.containsKey('profile_photo')) {
        _photoUrlController.text = response['profile_photo'] ?? '';
      }
    }

    // Update photo
    Future<void> _updatePhoto(String photoUrl) async {
      try {
        setState(() => isLoading = true);
        final response = await request.postJson(
          'https://redundant-raychel-bfq-f4b73b50.koyeb.app/update-photo-flutter/',
          jsonEncode(<String, String>{
            'photo_url': photoUrl,
          }),
        );

        if (response['status'] == 'success') {
          // Update UserProvider
          context.read<UserProvider>().updateUser(
            fullName: profileData!['full_name'] ?? '',
            email: profileData!['email'] ?? '',
            username: profileData!['username'] ?? '',
            age: profileData!['age'] ?? 0,
            gender: profileData!['gender']?? '',
            phoneNumber: profileData!['phone_number'] ?? '',
            role: profileData!['role'] ?? '',
            profilePhoto: photoUrl,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Close modal
          _fetchUserProfile(); // Refresh User Profile Page
        } else {
          throw Exception(response['message'] ?? 'Failed to update photo');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }

    // Delete photo
    Future<void> _deletePhoto() async {
      try {
        setState(() => isLoading = true);
        final response = await request.postJson(
          'https://redundant-raychel-bfq-f4b73b50.koyeb.app/delete-photo-flutter/',
          jsonEncode({}),
        );

        if (response['status'] == 'success') {
          context.read<UserProvider>().updateUser(
            fullName: profileData!['full_name'] ?? '',
            email: profileData!['email'] ?? '',
            username: profileData!['username'] ?? '',
            age: profileData!['age'] ?? 0,
            gender: profileData!['gender']?? '',
            phoneNumber: profileData!['phone_number'] ?? '',
            role: profileData!['role'] ?? '',
            profilePhoto: '',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Close modal
          _fetchUserProfile(); // Refresh User Profile Page
        } else {
          throw Exception(response['message'] ?? 'Failed to delete photo');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }

    _fetchCurrentPhoto();

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Sesuaikan padding
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24), // Batas dari tepi layar
          title: const Text(
            'Edit Photo',
            style: TextStyle(color: Color(0xFFB48125), fontSize: 18, fontWeight:FontWeight.bold), // Ukuran font lebih kecil
          ),
          content: SizedBox(
            width: 300, // Sesuaikan lebar modal
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _photoUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Photo URL',
                    labelStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(),
                    hintText: 'Enter the new photo URL',
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _deletePhoto,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Delete Photo', style: TextStyle(fontSize: 12)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _updatePhoto(_photoUrlController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB48125),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Save Changes', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _deleteAccountModal(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();
    bool isLoading = false;

    Future<void> _deleteAccount() async {
      final request = context.read<CookieRequest>();
      try {
        setState(() => isLoading = true);
        final response = await request.postJson(
          'https://redundant-raychel-bfq-f4b73b50.koyeb.app/delete-account-flutter/',
          jsonEncode(<String, String>{
            'username': _usernameController.text,
            'password': _passwordController.text,
            'confirm_password': _confirmPasswordController.text,
          }),
        );

        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Close modal
          context.read<UserProvider>().resetUser(); // Reset data user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Goodbye!"),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MenuPage(),
            ),
          );
        } else {
          throw Exception(response['error'] ?? 'Failed to delete account');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          title: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SizedBox(
            width: 300, // Sesuaikan lebar modal
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want to delete your account? This action cannot be undone.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close modal
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                          ),
                          ElevatedButton(
                            onPressed: _deleteAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Confirm Delete', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.primary,
      drawer: const LeftDrawer(),
      appBar: CustomLogoAppBar(
        scaffoldKey: _scaffoldKey,
        elevation: 6.0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 80),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EAD8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: profileData!['profile_photo'] != null
                                      ? NetworkImage(profileData!['profile_photo'])
                                      : const AssetImage(
                                          'assets/images/default-profile.jpg',
                                        ) as ImageProvider,
                                  onBackgroundImageError: (_, __) =>
                                      const Icon(Icons.error),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => _editPhotoModal(context),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFB48125),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Sesuaikan padding
                                    minimumSize: const Size(100, 40), // Ukuran minimum tombol
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Edit Photo",
                                    style: TextStyle(fontSize: 12), // Ukuran teks lebih kecil
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => _deleteAccountModal(context),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Sesuaikan padding
                                    minimumSize: const Size(100, 40), // Ukuran minimum tombol
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Delete Acc",
                                    style: TextStyle(fontSize: 12), // Ukuran teks lebih kecil
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      (profileData?['role'] == 'admin' 
                                        ? 'Admin' 
                                        : profileData?['full_name']) + "'s Profile",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFB48125),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (userProvider.role != 'admin') ...[
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const UserProfileEditPage(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.edit),
                                        color: const Color(0xFFB48125),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 20),
                                if (userProvider.role == 'admin') ...[
                                  _buildProfileItem("Email", profileData!['email']),
                                  _buildProfileItem("Date Joined",
                                      profileData!['date_joined'] ?? 'N/A'),
                                ] else ...[
                                  _buildProfileItem("Full Name", profileData!['full_name']),
                                  _buildProfileItem("Email", profileData!['email']),
                                  _buildProfileItem("Date Joined",
                                      profileData!['date_joined'] ?? 'N/A'),
                                  _buildProfileItem(
                                      "Age", profileData!['age']?.toString() ?? 'N/A'),
                                  _buildProfileItem(
                                      "Gender", profileData!['gender'] ?? 'N/A'),
                                  _buildProfileItem("Phone Number",
                                      profileData!['phone_number'] ?? 'N/A'),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB48125),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
