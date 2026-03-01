import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/usuario_entity.dart';
import '../repositories/auth_repository.dart';

class ObtenerUsuarioPorIdUseCase {
  final AuthRepository repository;

  ObtenerUsuarioPorIdUseCase(this.repository);

  Future<Either<Failure, UsuarioEntity?>> call(String id) {
    return repository.obtenerUsuarioPorId(id);
  }
}
