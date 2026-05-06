import '../entities/mensaje.dart';
import '../repositories/chat_repository.dart';

class ObtenerMensajesStreamUseCase {
  final ChatRepository repository;

  ObtenerMensajesStreamUseCase(this.repository);

  Stream<List<Mensaje>> call(String conversacionId) {
    return repository.obtenerMensajesStream(conversacionId);
  }
}
