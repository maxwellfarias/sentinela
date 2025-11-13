/// Modelo de usuário da API de autenticação
///
/// Representa os dados completos do usuário retornados pela API,
/// incluindo metadados, identidades e informações de confirmação
final class UserModel {
  final String id;
  final String aud;
  final String role;
  final String email;
  final String? emailConfirmedAt;
  final String phone;
  final String? confirmedAt;
  final String? lastSignInAt;
  final Map<String, dynamic>? appMetadata;
  final Map<String, dynamic>? userMetadata;
  final List<IdentityModel>? identities;
  final String? createdAt;
  final String? updatedAt;
  final bool isAnonymous;

  const UserModel({
    required this.id,
    required this.aud,
    required this.role,
    required this.email,
    this.emailConfirmedAt,
    required this.phone,
    this.confirmedAt,
    this.lastSignInAt,
    this.appMetadata,
    this.userMetadata,
    this.identities,
    this.createdAt,
    this.updatedAt,
    required this.isAnonymous,
  });

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      id: json['id'] ?? '',
      aud: json['aud'] ?? 'authenticated',
      role: json['role'] ?? 'authenticated',
      email: json['email'] ?? '',
      emailConfirmedAt: json['email_confirmed_at'],
      phone: json['phone'] ?? '',
      confirmedAt: json['confirmed_at'],
      lastSignInAt: json['last_sign_in_at'],
      appMetadata: json['app_metadata'] != null
          ? Map<String, dynamic>.from(json['app_metadata'])
          : null,
      userMetadata: json['user_metadata'] != null
          ? Map<String, dynamic>.from(json['user_metadata'])
          : null,
      identities: json['identities'] != null
          ? (json['identities'] as List)
              .map((identity) => IdentityModel.fromJson(identity))
              .toList()
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isAnonymous: json['is_anonymous'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aud': aud,
      'role': role,
      'email': email,
      'email_confirmed_at': emailConfirmedAt,
      'phone': phone,
      'confirmed_at': confirmedAt,
      'last_sign_in_at': lastSignInAt,
      'app_metadata': appMetadata,
      'user_metadata': userMetadata,
      'identities': identities?.map((identity) => identity.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_anonymous': isAnonymous,
    };
  }

  UserModel copyWith({
    String? id,
    String? aud,
    String? role,
    String? email,
    String? emailConfirmedAt,
    String? phone,
    String? confirmedAt,
    String? lastSignInAt,
    Map<String, dynamic>? appMetadata,
    Map<String, dynamic>? userMetadata,
    List<IdentityModel>? identities,
    String? createdAt,
    String? updatedAt,
    bool? isAnonymous,
  }) {
    return UserModel(
      id: id ?? this.id,
      aud: aud ?? this.aud,
      role: role ?? this.role,
      email: email ?? this.email,
      emailConfirmedAt: emailConfirmedAt ?? this.emailConfirmedAt,
      phone: phone ?? this.phone,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      appMetadata: appMetadata ?? this.appMetadata,
      userMetadata: userMetadata ?? this.userMetadata,
      identities: identities ?? this.identities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }

  @override
  String toString() {
    return 'UserModel('
        'id: $id, '
        'email: $email, '
        'role: $role, '
        'isAnonymous: $isAnonymous'
        ')';
  }
}

/// Modelo de identidade do usuário
///
/// Representa uma identidade de autenticação vinculada ao usuário
final class IdentityModel {
  final String identityId;
  final String id;
  final String userId;
  final Map<String, dynamic>? identityData;
  final String provider;
  final String? lastSignInAt;
  final String? createdAt;
  final String? updatedAt;
  final String? email;

  const IdentityModel({
    required this.identityId,
    required this.id,
    required this.userId,
    this.identityData,
    required this.provider,
    this.lastSignInAt,
    this.createdAt,
    this.updatedAt,
    this.email,
  });

  factory IdentityModel.fromJson(dynamic json) {
    return IdentityModel(
      identityId: json['identity_id'] ?? '',
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      identityData: json['identity_data'] != null
          ? Map<String, dynamic>.from(json['identity_data'])
          : null,
      provider: json['provider'] ?? '',
      lastSignInAt: json['last_sign_in_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identity_id': identityId,
      'id': id,
      'user_id': userId,
      'identity_data': identityData,
      'provider': provider,
      'last_sign_in_at': lastSignInAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'email': email,
    };
  }

  IdentityModel copyWith({
    String? identityId,
    String? id,
    String? userId,
    Map<String, dynamic>? identityData,
    String? provider,
    String? lastSignInAt,
    String? createdAt,
    String? updatedAt,
    String? email,
  }) {
    return IdentityModel(
      identityId: identityId ?? this.identityId,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      identityData: identityData ?? this.identityData,
      provider: provider ?? this.provider,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'IdentityModel('
        'identityId: $identityId, '
        'provider: $provider, '
        'email: $email'
        ')';
  }
}