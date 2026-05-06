import '../repositories/chat_repository.dart';

class MarcarMensajesComoLeidosUseCase {
  final ChatRepository repository;

  MarcarMensajesComoLeidosUseCase(this.repository);

  Future<void> call(String conversacionId, String miId) {
    return repository.marcarMensajesComoLeidos(conversacionId, miId);
  }
}
