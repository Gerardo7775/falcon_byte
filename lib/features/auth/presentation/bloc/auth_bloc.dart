import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../domain/usecases/login_microsoft_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC para autenticación con Microsoft
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginMicrosoftUseCase loginMicrosoftUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginMicrosoftUseCase,
    required this.logoutUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<VerificarSesionEvent>(_onVerificarSesion);
    on<LoginMicrosoftEvent>(_onLoginMicrosoft);
    on<LogoutEvent>(_onLogout);
  }

  /// Verifica si ya hay una sesión activa de Firebase Auth
  Future<void> _onVerificarSesion(
      VerificarSesionEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.obtenerUsuarioActual();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (usuario) {
        if (usuario != null) {
          emit(AuthAuthenticated(usuario));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginMicrosoft(
      LoginMicrosoftEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginMicrosoftUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (usuario) => emit(AuthAuthenticated(usuario)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
