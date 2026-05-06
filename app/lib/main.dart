import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'core/services/notificaciones_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificacionesService.inicializar();
  await setupDependencies();

  // Verificar si ya hay una sesión activa antes de iniciar
  final authBloc = sl<AuthBloc>();
  authBloc.add(VerificarSesionEvent());

  runApp(FalconByteApp(initialAuthBloc: authBloc));
}

/// Notifier global para el modo de tema
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

class FalconByteApp extends StatelessWidget {
  final AuthBloc initialAuthBloc;
  const FalconByteApp({super.key, required this.initialAuthBloc});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        return BlocProvider.value(
          value: initialAuthBloc,
          child: MaterialApp.router(
            title: 'FalconByte',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
