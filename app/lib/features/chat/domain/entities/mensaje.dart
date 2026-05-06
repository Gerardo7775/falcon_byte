import 'package:equatable/equatable.dart';

/// Define un mensaje individual en una conversación de chat.
class Mensaje extends Equatable {
  final String id;
  final String senderId;
  final String texto;
  final DateTime timestamp;
  final bool leido;

  const Mensaje({
    required this.id,
    required this.senderId,
    required this.texto,
    required this.timestamp,
    this.leido = false,
  });

  @override
  List<Object?> get props => [id, senderId, texto, timestamp, leido];
}
