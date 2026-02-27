import 'package:equatable/equatable.dart';

/// Clase base para todos los errores de la aplicación
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Error del servidor
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error del servidor']);
}

/// Error de autenticación
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Error de autenticación']);
}

/// Error de red
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Error de conexión']);
}

/// Error de caché
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error de caché']);
}

/// Error de validación
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Error de validación']);
}

/// Error no encontrado
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'No encontrado']);
}

/// Error de permisos
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Sin permisos']);
}
