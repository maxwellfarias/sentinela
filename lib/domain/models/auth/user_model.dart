class UserModel {
  final String id;
  final String nome;
  final String cpf;
  final String? email;

  UserModel({
    required this.id,
    required this.nome,
    required this.cpf,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'email': email,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      cpf: json['cpf'] as String,
      email: json['email'] as String?,
    );
  }

  UserModel copyWith({
    String? id,
    String? nome,
    String? cpf,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
    );
  }
}
