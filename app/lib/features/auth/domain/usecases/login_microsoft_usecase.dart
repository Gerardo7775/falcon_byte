import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/usuario_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case para login con Microsoft
class LoginMicrosoftUseCase implements UseCase<UsuarioEntity, NoParams> {
  final AuthRepository repository;

  LoginMicrosoftUseCase(this.repository);

  @override
  Future<Either<Failure, UsuarioEntity>> call(NoParams params) {
    return repository.loginConMicrosoft();
  }
}
