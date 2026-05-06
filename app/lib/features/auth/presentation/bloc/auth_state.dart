part of 'auth_bloc.dart';

/// Estados de autenticación
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuthInitial extends AuthState {}

/// Estado de carga
class AuthLoading extends AuthState {}

/// Estado autenticado
class AuthAuthenticated extends AuthState {
  final UsuarioEntity usuario;

  const AuthAuthenticated(this.usuario);

  @override
  List<Object> get props => [usuario];
}

/// Estado no autenticado
class AuthUnauthenticated extends AuthState {}

/// Estado de error
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
