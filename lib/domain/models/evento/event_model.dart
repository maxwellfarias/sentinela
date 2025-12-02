/// Modelo de dados para Evento
final class EventModel {
  final int id;
  final String name;
  final List<String> speakerAvatars;
  final int speakerCount;
  final int remainingSeats;
  final int totalSeats;
  final String? googleMeetLink;
  final DateTime date;
  final String duration;

  const EventModel({
    required this.id,
    required this.name,
    required this.speakerAvatars,
    required this.speakerCount,
    required this.remainingSeats,
    required this.totalSeats,
    this.googleMeetLink,
    required this.date,
    required this.duration,
  });

  /// Calcula a porcentagem de ocupação
  double get occupancyPercentage =>
      totalSeats > 0 ? ((totalSeats - remainingSeats) / totalSeats) * 100 : 0;

  /// Retorna a cor da barra de progresso baseado na ocupação
  String get progressColor {
    if (occupancyPercentage >= 80) return 'green';
    if (occupancyPercentage >= 50) return 'yellow';
    return 'red';
  }

  EventModel copyWith({
    int? id,
    String? name,
    List<String>? speakerAvatars,
    int? speakerCount,
    int? remainingSeats,
    int? totalSeats,
    String? googleMeetLink,
    DateTime? date,
    String? duration,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      speakerAvatars: speakerAvatars ?? this.speakerAvatars,
      speakerCount: speakerCount ?? this.speakerCount,
      remainingSeats: remainingSeats ?? this.remainingSeats,
      totalSeats: totalSeats ?? this.totalSeats,
      googleMeetLink: googleMeetLink ?? this.googleMeetLink,
      date: date ?? this.date,
      duration: duration ?? this.duration,
    );
  }
}
