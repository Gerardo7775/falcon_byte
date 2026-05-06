import '../../domain/entities/mensaje.dart';

class MensajeModel extends Mensaje {
  const MensajeModel({
    required super.id,
    required super.senderId,
    required super.texto,
    required super.timestamp,
    super.leido,
  });

  factory MensajeModel.fromJson(String id, Map<dynamic, dynamic> json) {
    return MensajeModel(
      id: id,
      senderId: json['senderId'] ?? '',
      texto: json['texto'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] ?? 0),
      leido: json['leido'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'texto': texto,
      'timestamp': timestamp.millisecondsSinceEpoch, // RTDB prefiere enteros
      'leido': leido,
    };
  }

  factory MensajeModel.fromEntity(Mensaje entity) {
    return MensajeModel(
      id: entity.id,
      senderId: entity.senderId,
      texto: entity.texto,
      timestamp: entity.timestamp,
      leido: entity.leido,
    );
  }
}
