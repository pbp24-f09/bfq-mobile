class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final int? age;
  final String? gender;
  final String? phoneNumber;
  final String? profilePhoto;
  final bool isAdmin;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.age,
    this.gender,
    this.phoneNumber,
    this.profilePhoto,
    required this.isAdmin,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      age: json['age'],
      gender: json['gender'],
      phoneNumber: json['phone_number'],
      profilePhoto: json['profile_photo'],
      isAdmin: json['is_admin'],
    );
  }
}