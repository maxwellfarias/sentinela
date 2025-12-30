final class CurrentSession {
  final String accessToken;
  final int expiresAt;
  final String refreshToken;
  CurrentSession({
    required this.accessToken,
    required this.expiresAt,
    required this.refreshToken,
  });
  factory CurrentSession.fromJson(Map<String, dynamic> json) {
    return CurrentSession(
      accessToken: json['access_token'],
      expiresAt: json['expires_at'],
      refreshToken: json['refresh_token'],
    );
  }
}