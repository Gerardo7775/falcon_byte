import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/conversacion.dart';
import 'mensaje_model.dart';

class ConversacionModel extends Conversacion {
  const ConversacionModel({
    required super.id,
    required super.participantesIds,
    super.ultimoMensaje,
    required super.fechaActualizacion,
    super.participantesDetalles,
  });

  factory ConversacionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    MensajeModel? lastMessage;
    if (data['ultimoMensaje'] != null) {
      lastMessage = MensajeModel.fromJson(
          'lastMsg', data['ultimoMensaje'] as Map<dynamic, dynamic>);
    }

    return ConversacionModel(
      id: doc.id,
      participantesIds: List<String>.from(data['participantesIds'] ?? []),
      ultimoMensaje: lastMessage,
      fechaActualizacion:
          (data['fechaActualizacion'] as Timestamp?)?.toDate() ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantesIds': participantesIds,
      'ultimoMensaje': ultimoMensaje != null
          ? MensajeModel.fromEntity(ultimoMensaje!).toJson()
          : null,
      'fechaActualizacion': Timestamp.fromDate(fechaActualizacion),
    };
  }
}
