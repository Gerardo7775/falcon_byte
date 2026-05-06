import 'dart:async';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/conversacion.dart';
import '../../domain/entities/mensaje.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Conversacion>> obtenerConversacionesStream(String usuarioId) {
    // Convierte explícitamente Stream<List<ConversacionModel>> a Stream<List<Conversacion>>
    return remoteDataSource
        .obtenerConversacionesStream(usuarioId)
        .handleError((error) {
      throw ServerFailure(error.toString());
    }).map((models) => models.cast<Conversacion>());
  }

  @override
  Stream<List<Mensaje>> obtenerMensajesStream(String conversacionId) {
    return remoteDataSource
        .obtenerMensajesStream(conversacionId)
        .handleError((error) {
      throw ServerFailure(error.toString());
    }).map((models) => models.cast<Mensaje>());
  }

  @override
  Future<void> enviarMensaje({
    required String conversacionId,
    required String senderId,
    required String texto,
  }) async {
    try {
      await remoteDataSource.enviarMensaje(
        conversacionId: conversacionId,
        senderId: senderId,
        texto: texto,
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<String> iniciarConversacion(String miId, String otroUsuarioId) async {
    try {
      return await remoteDataSource.iniciarConversacion(miId, otroUsuarioId);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> marcarMensajesComoLeidos(
      String conversacionId, String miId) async {
    try {
      await remoteDataSource.marcarMensajesComoLeidos(conversacionId, miId);
    } catch (e) {
      // Silencioso ya que marcar leído no es crítico
    }
  }
}
