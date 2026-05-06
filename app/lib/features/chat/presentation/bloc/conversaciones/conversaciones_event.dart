import 'package:equatable/equatable.dart';

import '../../../domain/entities/conversacion.dart';

abstract class ConversacionesEvent extends Equatable {
  const ConversacionesEvent();

  @override
  List<Object> get props => [];
}

class IniciarStreamConversaciones extends ConversacionesEvent {
  final String usuarioId;
  const IniciarStreamConversaciones(this.usuarioId);

  @override
  List<Object> get props => [usuarioId];
}

class ActualizarConversacionesEvent extends ConversacionesEvent {
  final List<Conversacion> conversaciones;
  const ActualizarConversacionesEvent(this.conversaciones);

  @override
  List<Object> get props => [conversaciones];
}
