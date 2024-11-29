import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
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
      final response = await request.get('http://127.0.0.1:8000/profile-flutter/');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF102820), // Warna gradasi latar belakang
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: const Color(0xFF172810),
        centerTitle: true,
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
                      margin: const EdgeInsets.symmetric(vertical: 40),
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
                          // Kolom kiri: Foto profil dan tombol
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: profileData!['profile_photo'] != null
                                      ? NetworkImage(profileData!['profile_photo'])
                                      : const AssetImage('assets/images/default-profile.jpg')
                                          as ImageProvider,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    // Aksi untuk Edit Foto
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFB48125),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text("Edit Photo"),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    // Aksi untuk Delete Account
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor : Colors.red,
                                    foregroundColor : Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text("Delete Account"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Kolom kanan: Informasi Profil
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileData!['is_admin'] == true
                                      ? "Admin's Profile"
                                      : "${profileData!['full_name']}'s Profile",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB48125),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Informasi Profil
                                _buildProfileItem("Full Name", profileData!['full_name']),
                                _buildProfileItem("Email", profileData!['email']),
                                _buildProfileItem(
                                  "Date Joined",
                                  profileData!['date_joined'] ?? 'N/A',
                                ),
                                _buildProfileItem("Age", profileData!['age']?.toString() ?? 'N/A'),
                                _buildProfileItem("Gender", profileData!['gender'] ?? 'N/A'),
                                _buildProfileItem(
                                  "Phone Number",
                                  profileData!['phone_number'] ?? 'N/A',
                                ),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB48125),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}