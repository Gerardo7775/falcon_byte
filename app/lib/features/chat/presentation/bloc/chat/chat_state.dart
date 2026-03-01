import 'package:equatable/equatable.dart';

import '../../../domain/entities/mensaje.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Mensaje> mensajes;

  const ChatLoaded(this.mensajes);

  @override
  List<Object> get props => [mensajes];
}

class ChatError extends ChatState {
  final String mensaje;

  const ChatError(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}
