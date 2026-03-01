import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/usuario_entity.dart';
import '../repositories/auth_repository.dart';

class BuscarUsuariosUseCase {
  final AuthRepository repository;

  BuscarUsuariosUseCase(this.repository);

  Future<Either<Failure, List<UsuarioEntity>>> call(String query) {
    return repository.buscarUsuariosPorNombre(query);
  }
}
