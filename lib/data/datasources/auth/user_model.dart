class UserModel {
  final String id;
  final String email;
  final String name;
  final String accessToken;
  final int expiresAt;
  final String refreshToken;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.accessToken,
    required this.expiresAt,
    required this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      accessToken: map['access_token'] ?? '',
      expiresAt: map['expires_at'] ?? '',
      refreshToken: map['refresh_token'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? accessToken,
    int? expiresAt,
    String? refreshToken, 
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      accessToken: accessToken ?? this.accessToken,
      expiresAt: expiresAt ?? this.expiresAt,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}