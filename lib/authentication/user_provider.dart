import 'package:flutter/material.dart';



class UserProvider with ChangeNotifier {
  // Fields
  String _fullName = '';
  String _profilePhoto = '';
  String _username = '';
  String _email = '';
  int _age = 0;
  String _gender = '';
  String _phoneNumber = '';
  String _role = '';

  // Getters
  String get fullName => _fullName;
  String get profilePhoto => _profilePhoto;
  String get username => _username;
  String get email => _email;
  int get age => _age;
  String get gender => _gender;
  String get phoneNumber => _phoneNumber;
  String get role => _role;

  // Setters
  void updateUser({
    required String fullName,
    required String profilePhoto,
    required String username,
    required String email,
    required int age,
    required String gender,
    required String phoneNumber,
    required String role,
  }) {
    _fullName = fullName;
    _profilePhoto = profilePhoto;
    _username = username;
    _email = email;
    _age = age;
    _gender = gender;
    _phoneNumber = phoneNumber;
    _role = role;

    notifyListeners(); // Memberitahu semua widget terkait bahwa data telah berubah
  }

  // Reset User Data (Misalnya saat logout)
  void resetUser() {
    _fullName = '';
    _profilePhoto = '';
    _username = '';
    _email = '';
    _age = 0;
    _gender = '';
    _phoneNumber = '';
    _role = '';

    notifyListeners(); // Reset akan memengaruhi widget terkait
  }

}
