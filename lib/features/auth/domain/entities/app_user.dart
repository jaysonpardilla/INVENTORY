// inventory/lib/models/app_user.dart
class AppUser {
  String id;
  String username;
  String email;
  String profileUrl;


  AppUser({
    required this.id,
    required this.username,
    required this.email,
    this.profileUrl = '',
  });

  Map<String, dynamic> toMap() => {
        'username': username,
        'email': email,
        'profileUrl': profileUrl,
      };

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profileUrl: map['profileUrl'] ?? '',
    );
  }
}
