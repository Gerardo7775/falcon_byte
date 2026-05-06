import '../entities/conversacion.dart';
import '../entities/mensaje.dart';

/// Contrato abstracto para el repositorio del Chat
abstract class ChatRepository {
  /// Devuelve el Stream en tiempo real de los chats activos del usuario.
  Stream<List<Conversacion>> obtenerConversacionesStream(String usuarioId);

  /// Devuelve un Stream de mensajes de una conversación específica en Realtime Database.
  Stream<List<Mensaje>> obtenerMensajesStream(String conversacionId);

  /// Envía un mensaje instantáneo de texto a una sala.
  Future<void> enviarMensaje({
    required String conversacionId,
    required String senderId,
    required String texto,
  });

  /// Crea o devuelve la ID de una sala de chat existente entre dos personas.
  Future<String> iniciarConversacion(String miId, String otroUsuarioId);

  /// Marca los mensajes de una conversación como leídos
  Future<void> marcarMensajesComoLeidos(String conversacionId, String miId);
}
