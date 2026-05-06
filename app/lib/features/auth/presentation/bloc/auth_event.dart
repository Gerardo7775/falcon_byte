part of 'auth_bloc.dart';

/// Eventos de autenticación
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Verificar si ya hay sesión activa (al arrancar la app)
class VerificarSesionEvent extends AuthEvent {}

/// Iniciar sesión con Microsoft
class LoginMicrosoftEvent extends AuthEvent {}

/// Cerrar sesión
class LogoutEvent extends AuthEvent {}
