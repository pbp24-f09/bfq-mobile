import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bfq/authentication/models/user.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Get User Profile
  Future<UserProfile> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/profile/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  // Update User Profile
  Future<void> updateUserProfile(String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/profile/update/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user profile');
    }
  }

  // Update Profile Photo
  Future<void> updateProfilePhoto(String token, String photoUrl) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/profile/photo/update/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'profile_photo': photoUrl}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile photo');
    }
  }

  // Delete Profile Photo
  Future<void> deleteProfilePhoto(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/profile/photo/delete/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete profile photo');
    }
  }

  // Delete Account
  Future<void> deleteAccount(String token, String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/account/delete/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete account');
    }
  }
}