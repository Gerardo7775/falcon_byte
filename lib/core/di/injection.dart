import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/actualizar_perfil_usecase.dart';
import '../../features/auth/domain/usecases/buscar_usuarios_usecase.dart';
import '../../features/auth/domain/usecases/login_microsoft_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/obtener_usuario_actual_usecase.dart';
import '../../features/auth/domain/usecases/obtener_usuario_por_id_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Chat
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/enviar_mensaje_usecase.dart';
import '../../features/chat/domain/usecases/iniciar_conversacion_usecase.dart';
import '../../features/chat/domain/usecases/marcar_mensajes_leidos_usecase.dart';
import '../../features/chat/domain/usecases/obtener_conversaciones_stream_usecase.dart';
import '../../features/chat/domain/usecases/obtener_mensajes_stream_usecase.dart';
import '../../features/chat/presentation/bloc/chat/chat_bloc.dart';
import '../../features/chat/presentation/bloc/conversaciones/conversaciones_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // ============ Firebase ============
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() {
    final firestore = FirebaseFirestore.instance;
    // IMPORTANTE: Desactivar caché local temporalmente para forzar
    // a la app a leer la nueva base de datos y quitar el error NOT_FOUND
    firestore.settings = const Settings(persistenceEnabled: false);
    return firestore;
  });
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => FirebaseDatabase.instance);

  // ============ Auth Feature ============
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => LoginMicrosoftUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ActualizarPerfilUseCase(sl()));
  sl.registerLazySingleton(() => BuscarUsuariosUseCase(sl()));
  sl.registerLazySingleton(() => ObtenerUsuarioActualUseCase(sl()));
  sl.registerLazySingleton(() => ObtenerUsuarioPorIdUseCase(sl()));

  // AuthBloc como singleton para que persista en toda la app
  sl.registerLazySingleton(
    () => AuthBloc(
      loginMicrosoftUseCase: sl(),
      logoutUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // ============ Chat Feature ============
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      firestore: sl(),
      realTimeDb: sl(),
    ),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => EnviarMensajeUseCase(sl()));
  sl.registerLazySingleton(() => MarcarMensajesComoLeidosUseCase(sl()));
  sl.registerLazySingleton(() => ObtenerConversacionesStreamUseCase(sl()));
  sl.registerLazySingleton(() => ObtenerMensajesStreamUseCase(sl()));
  sl.registerLazySingleton(() => IniciarConversacionUseCase(sl()));

  sl.registerFactory(() => ConversacionesBloc(
        obtenerConversacionesUseCase: sl(),
      ));
  sl.registerFactory(() => ChatBloc(
        obtenerMensajesUseCase: sl(),
        enviarMensajeUseCase: sl(),
        marcarMensajesComoLeidosUseCase: sl(),
      ));
}
