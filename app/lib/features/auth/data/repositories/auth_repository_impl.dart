import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementación del repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UsuarioEntity>> loginConMicrosoft() async {
    try {
      final usuario = await remoteDataSource.loginConMicrosoft();
      return Right(usuario.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UsuarioEntity?>> obtenerUsuarioActual() async {
    try {
      final usuario = await remoteDataSource.obtenerUsuarioActual();
      return Right(usuario?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<UsuarioEntity?> get estadoAuth {
    return remoteDataSource.estadoAuth.map((u) => u?.toEntity());
  }

  @override
  Future<Either<Failure, UsuarioEntity>> actualizarPerfil({
    required String userId,
    String? nombre,
    String? telefono,
    String? fotoUrl,
  }) async {
    try {
      final usuario = await remoteDataSource.actualizarPerfil(
        userId: userId,
        nombre: nombre,
        telefono: telefono,
        fotoUrl: fotoUrl,
      );
      return Right(usuario.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UsuarioEntity>>> buscarUsuariosPorNombre(
      String query) async {
    try {
      final modelos = await remoteDataSource.buscarUsuariosPorNombre(query);
      return Right(modelos.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UsuarioEntity?>> obtenerUsuarioPorId(String id) async {
    try {
      final modelo = await remoteDataSource.obtenerUsuarioPorId(id);
      return Right(modelo?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
