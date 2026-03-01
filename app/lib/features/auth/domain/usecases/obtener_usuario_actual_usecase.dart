import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/usuario_entity.dart';
import '../repositories/auth_repository.dart';

class ObtenerUsuarioActualUseCase {
  final AuthRepository repository;

  ObtenerUsuarioActualUseCase(this.repository);

  Future<Either<Failure, UsuarioEntity?>> call() {
    return repository.obtenerUsuarioActual();
  }
}
