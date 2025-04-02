class UserModel {
  final String uid;
  final String email;
  final String role;
  final Map<String, dynamic> profile;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.profile,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      profile: data['profile'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'profile': profile,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? role,
    Map<String, dynamic>? profile,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      profile: profile ?? this.profile,
    );
  }
}
