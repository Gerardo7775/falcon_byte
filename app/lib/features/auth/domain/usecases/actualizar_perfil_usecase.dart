import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/usuario_entity.dart';
import '../repositories/auth_repository.dart';

class ActualizarPerfilUseCase {
  final AuthRepository repository;

  ActualizarPerfilUseCase(this.repository);

  Future<Either<Failure, UsuarioEntity>> call({
    required String userId,
    String? nombre,
    String? telefono,
    String? fotoUrl,
  }) {
    return repository.actualizarPerfil(
      userId: userId,
      nombre: nombre,
      telefono: telefono,
      fotoUrl: fotoUrl,
    );
  }
}
