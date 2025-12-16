/// Model para representar um alerta de veículo no mapa de patrulha
final class VehicleAlertModel {
  final int id;
  final String modelo;
  final String marca;
  final String placa;
  final String cor;
  final VehicleAlertType tipo;
  final double latitude;
  final double longitude;
  final double distanciaKm;
  final DateTime horaDeteccao;
  final String? imagemUrl;

  const VehicleAlertModel({
    required this.id,
    required this.modelo,
    required this.marca,
    required this.placa,
    required this.cor,
    required this.tipo,
    required this.latitude,
    required this.longitude,
    required this.distanciaKm,
    required this.horaDeteccao,
    this.imagemUrl,
  });

  /// Retorna o nome completo do veículo (marca + modelo)
  String get nomeCompleto => '$marca $modelo';

  /// Retorna a hora formatada da detecção
  String get horaFormatada {
    final hora = horaDeteccao.hour.toString().padLeft(2, '0');
    final minuto = horaDeteccao.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  /// Retorna a distância formatada
  String get distanciaFormatada => '${distanciaKm.toStringAsFixed(1)} km';

  /// Retorna o tempo desde a detecção
  String get tempoDesdeDeteccao {
    final agora = DateTime.now();
    final diferenca = agora.difference(horaDeteccao);

    if (diferenca.inMinutes < 1) {
      return 'Agora';
    } else if (diferenca.inMinutes < 60) {
      return 'há ${diferenca.inMinutes} min';
    } else if (diferenca.inHours < 24) {
      return 'há ${diferenca.inHours}h';
    } else {
      return 'há ${diferenca.inDays}d';
    }
  }

  VehicleAlertModel copyWith({
    int? id,
    String? modelo,
    String? marca,
    String? placa,
    String? cor,
    VehicleAlertType? tipo,
    double? latitude,
    double? longitude,
    double? distanciaKm,
    DateTime? horaDeteccao,
    String? imagemUrl,
  }) {
    return VehicleAlertModel(
      id: id ?? this.id,
      modelo: modelo ?? this.modelo,
      marca: marca ?? this.marca,
      placa: placa ?? this.placa,
      cor: cor ?? this.cor,
      tipo: tipo ?? this.tipo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanciaKm: distanciaKm ?? this.distanciaKm,
      horaDeteccao: horaDeteccao ?? this.horaDeteccao,
      imagemUrl: imagemUrl ?? this.imagemUrl,
    );
  }

  factory VehicleAlertModel.fromJson(Map<String, dynamic> json) {
    return VehicleAlertModel(
      id: json['id'] as int,
      modelo: json['modelo'] as String,
      marca: json['marca'] as String,
      placa: json['placa'] as String,
      cor: json['cor'] as String,
      tipo: VehicleAlertType.fromString(json['tipo'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distanciaKm: (json['distancia_km'] as num).toDouble(),
      horaDeteccao: DateTime.parse(json['hora_deteccao'] as String),
      imagemUrl: json['imagem_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelo': modelo,
      'marca': marca,
      'placa': placa,
      'cor': cor,
      'tipo': tipo.value,
      'latitude': latitude,
      'longitude': longitude,
      'distancia_km': distanciaKm,
      'hora_deteccao': horaDeteccao.toIso8601String(),
      'imagem_url': imagemUrl,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleAlertModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Tipos de alerta de veículo
enum VehicleAlertType {
  roubado('roubado', 'Roubado'),
  furtado('furtado', 'Furtado'),
  procurado('procurado', 'Procurado'),
  irregular('irregular', 'Irregular'),
  suspeito('suspeito', 'Suspeito');

  final String value;
  final String label;

  const VehicleAlertType(this.value, this.label);

  static VehicleAlertType fromString(String value) {
    return VehicleAlertType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VehicleAlertType.suspeito,
    );
  }
}
