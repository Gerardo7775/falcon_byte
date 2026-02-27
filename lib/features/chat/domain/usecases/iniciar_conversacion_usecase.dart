import '../repositories/chat_repository.dart';

class IniciarConversacionUseCase {
  final ChatRepository repository;

  IniciarConversacionUseCase(this.repository);

  Future<String> call(String miId, String otroUsuarioId) {
    return repository.iniciarConversacion(miId, otroUsuarioId);
  }
}
