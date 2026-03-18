import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/conversacion_model.dart';
import '../models/mensaje_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ConversacionModel>> obtenerConversacionesStream(String usuarioId);
  Stream<List<MensajeModel>> obtenerMensajesStream(String conversacionId);
  Future<void> enviarMensaje({
    required String conversacionId,
    required String senderId,
    required String texto,
  });
  Future<String> iniciarConversacion(String miId, String otroId);
  Future<void> marcarMensajesComoLeidos(String conversacionId, String miId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseDatabase realTimeDb;

  ChatRemoteDataSourceImpl({
    required this.firestore,
    required this.realTimeDb,
  });

  @override
  Stream<List<ConversacionModel>> obtenerConversacionesStream(
      String usuarioId) {
    try {
      return firestore
          .collection(AppConstants.conversacionesCollection)
          .where('participantesIds', arrayContains: usuarioId)
          .orderBy('fechaActualizacion', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ConversacionModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      throw ServerException('Error al obtener conversaciones: $e');
    }
  }

  @override
  Stream<List<MensajeModel>> obtenerMensajesStream(String conversacionId) {
    try {
      final ref = realTimeDb.ref('mensajes/$conversacionId');

      // limitToLast para evitar cargar historiales gigantes al instante.
      return ref.limitToLast(100).onValue.map((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data == null) return [];

        final mensajes = data.entries.map((entry) {
          return MensajeModel.fromJson(
              entry.key.toString(), entry.value as Map<dynamic, dynamic>);
        }).toList();

        // RTDB no garantiza ordenamiento en el mapa devuelto, lo ordenamos por timestamp.
        mensajes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return mensajes;
      });
    } catch (e) {
      throw ServerException('Error al obtener mensajes de RTDB: $e');
    }
  }

  @override
  Future<void> enviarMensaje({
    required String conversacionId,
    required String senderId,
    required String texto,
  }) async {
    try {
      // 1. Enviar el mensaje a RTDB (Rápido)
      final ref = realTimeDb.ref('mensajes/$conversacionId').push();
      final ahora = DateTime.now();

      final nuevoMensaje = MensajeModel(
        id: ref.key ?? ahora.millisecondsSinceEpoch.toString(),
        senderId: senderId,
        texto: texto,
        timestamp: ahora,
        leido: false,
      );

      await ref.set(nuevoMensaje.toJson());

      // 2. Actualizar la metadata de la sala en Firestore (Para la lista de "Mis Chats")
      // IMPORTANTE: ultimoMensaje debe ser string (no Map) porque el backend
      // lo lee como string para armar el cuerpo de la notificación push.
      // remitenteUltimoMensaje es crítico: sin él, el backend aborta el push.
      await firestore
          .collection(AppConstants.conversacionesCollection)
          .doc(conversacionId)
          .update({
        'ultimoMensaje': texto,
        'remitenteUltimoMensaje': senderId,
        'fechaActualizacion': Timestamp.fromDate(ahora),
      });
    } catch (e) {
      throw ServerException('Error al enviar el mensaje: $e');
    }
  }

  @override
  Future<String> iniciarConversacion(String miId, String otroId) async {
    try {
      // Buscar si ya existe la sala exacta entre ambos
      final snaps = await firestore
          .collection(AppConstants.conversacionesCollection)
          .where('participantesIds', arrayContains: miId)
          .get();

      for (var doc in snaps.docs) {
        final participantes =
            List<String>.from(doc.data()['participantesIds'] ?? []);
        if (participantes.contains(otroId) && participantes.length == 2) {
          // La conversación existe
          return doc.id;
        }
      }

      // Si no existe, crear nueva sala de Firestore
      final newDocRef =
          firestore.collection(AppConstants.conversacionesCollection).doc();
      final nuevaConvo = ConversacionModel(
        id: newDocRef.id,
        participantesIds: [miId, otroId],
        fechaActualizacion: DateTime.now(),
      );

      await newDocRef.set(nuevaConvo.toJson());
      return newDocRef.id;
    } catch (e) {
      throw ServerException('Error al iniciar o buscar conversación: $e');
    }
  }

  @override
  Future<void> marcarMensajesComoLeidos(
      String conversacionId, String miId) async {
    try {
      final ref = realTimeDb.ref('mensajes/$conversacionId');
      final event = await ref.once();
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final Map<String, dynamic> updates = {};
        for (var entry in data.entries) {
          final msjData = entry.value as Map<dynamic, dynamic>;
          // Si no está leído y no soy yo el remitente
          if (!(msjData['leido'] ?? false) && msjData['senderId'] != miId) {
            updates['${entry.key}/leido'] = true;
          }
        }

        if (updates.isNotEmpty) {
          await ref.update(updates);
        }
      }
    } catch (e) {
      throw ServerException('Error marcando mensajes leídos: $e');
    }
  }
}
