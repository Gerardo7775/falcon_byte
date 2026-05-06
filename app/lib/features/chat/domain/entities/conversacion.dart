import 'package:equatable/equatable.dart';

import '../../../auth/data/models/usuario_model.dart';
import 'mensaje.dart';

/// Define una sala de chat entre dos o más usuarios.
class Conversacion extends Equatable {
  final String id;
  final List<String> participantesIds;
  final Mensaje? ultimoMensaje;
  final DateTime fechaActualizacion;

  // Datos locales de los participantes agregados en la UI o el Repository
  // (no siempre vienen de Firestore, se consultan ad-hoc).
  final List<UsuarioModel>? participantesDetalles;

  const Conversacion({
    required this.id,
    required this.participantesIds,
    this.ultimoMensaje,
    required this.fechaActualizacion,
    this.participantesDetalles,
  });

  Conversacion copyWith({
    String? id,
    List<String>? participantesIds,
    Mensaje? ultimoMensaje,
    DateTime? fechaActualizacion,
    List<UsuarioModel>? participantesDetalles,
  }) {
    return Conversacion(
      id: id ?? this.id,
      participantesIds: participantesIds ?? this.participantesIds,
      ultimoMensaje: ultimoMensaje ?? this.ultimoMensaje,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      participantesDetalles:
          participantesDetalles ?? this.participantesDetalles,
    );
  }

  @override
  List<Object?> get props => [
        id,
        participantesIds,
        ultimoMensaje,
        fechaActualizacion,
        participantesDetalles,
      ];
}
