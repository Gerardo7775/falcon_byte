import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/usuario_entity.dart';

/// Contrato del repositorio de autenticación
abstract class AuthRepository {
  /// Login exclusivo con cuenta Microsoft institucional
  Future<Either<Failure, UsuarioEntity>> loginConMicrosoft();

  /// Cerrar sesión
  Future<Either<Failure, void>> logout();

  /// Obtener usuario autenticado actual
  Future<Either<Failure, UsuarioEntity?>> obtenerUsuarioActual();

  /// Stream del estado de autenticación
  Stream<UsuarioEntity?> get estadoAuth;

  /// Actualizar perfil del usuario
  Future<Either<Failure, UsuarioEntity>> actualizarPerfil({
    required String userId,
    String? nombre,
    String? telefono,
    String? fotoUrl,
  });
}
