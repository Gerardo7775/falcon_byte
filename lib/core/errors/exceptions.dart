/// Excepciones personalizadas para la capa de datos
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Error del servidor']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Error de autenticación']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Error de conexión']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Error de caché']);
}

class ValidationException implements Exception {
  final String message;
  const ValidationException([this.message = 'Error de validación']);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'No encontrado']);
}
