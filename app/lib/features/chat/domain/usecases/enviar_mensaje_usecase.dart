import '../repositories/chat_repository.dart';

class EnviarMensajeUseCase {
  final ChatRepository repository;

  EnviarMensajeUseCase(this.repository);

  Future<void> call({
    required String conversacionId,
    required String senderId,
    required String texto,
  }) {
    return repository.enviarMensaje(
      conversacionId: conversacionId,
      senderId: senderId,
      texto: texto,
    );
  }
}
