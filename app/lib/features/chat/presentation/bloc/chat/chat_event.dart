import 'package:equatable/equatable.dart';

import '../../../domain/entities/mensaje.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class IniciarChatStreamEvent extends ChatEvent {
  final String conversacionId;

  const IniciarChatStreamEvent(this.conversacionId);

  @override
  List<Object> get props => [conversacionId];
}

class ActualizarMensajesEvent extends ChatEvent {
  final List<Mensaje> mensajes;

  const ActualizarMensajesEvent(this.mensajes);

  @override
  List<Object> get props => [mensajes];
}

class EnviarMensajeEvent extends ChatEvent {
  final String conversacionId;
  final String senderId;
  final String texto;

  const EnviarMensajeEvent({
    required this.conversacionId,
    required this.senderId,
    required this.texto,
  });

  @override
  List<Object> get props => [conversacionId, senderId, texto];
}

class MarcarComoLeidosEvent extends ChatEvent {
  final String conversacionId;
  final String miId;

  const MarcarComoLeidosEvent({
    required this.conversacionId,
    required this.miId,
  });

  @override
  List<Object> get props => [conversacionId, miId];
}
