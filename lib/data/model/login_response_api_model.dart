class LoginResponseApiModel {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final int expiresAt;
  final String refreshToken;
  final UserApiModel user;
  final dynamic weakPassword;

  LoginResponseApiModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
    required this.refreshToken,
    required this.user,
    this.weakPassword,
  });

  factory LoginResponseApiModel.fromJson(dynamic json) {
    return LoginResponseApiModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      expiresAt: json['expires_at'],
      refreshToken: json['refresh_token'],
      user: UserApiModel.fromJson(json['user']),
      weakPassword: json['weak_password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'expires_at': expiresAt,
      'refresh_token': refreshToken,
      'user': user.toJson(),
      'weak_password': weakPassword,
    };
  }
}

final class SessionApiModel {

}

class UserApiModel {
  final String id;
  final String email;
  final String phone;

  UserApiModel({required this.id, required this.email, required this.phone});

  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(id: json['id'], email: json['email'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'phone': phone};
  }
}
