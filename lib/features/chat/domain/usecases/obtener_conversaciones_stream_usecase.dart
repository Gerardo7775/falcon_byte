import '../entities/conversacion.dart';
import '../repositories/chat_repository.dart';

class ObtenerConversacionesStreamUseCase {
  final ChatRepository repository;

  ObtenerConversacionesStreamUseCase(this.repository);

  Stream<List<Conversacion>> call(String usuarioId) {
    return repository.obtenerConversacionesStream(usuarioId);
  }
}
