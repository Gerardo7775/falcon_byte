import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/injection.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/chat/presentation/bloc/chat/chat_bloc.dart';
import '../../features/chat/presentation/bloc/conversaciones/conversaciones_bloc.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/screens/conversaciones_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/perfil_screen.dart';

/// Configuración de GoRouter con redirección según estado de auth
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      // Se maneja en los listeners de cada pantalla
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/perfil',
        name: 'perfil',
        builder: (context, state) => const PerfilScreen(),
      ),
      // --- Chat Feature ---
      GoRoute(
        path: '/conversaciones',
        name: 'conversaciones',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<ConversacionesBloc>(),
          child: const ConversacionesScreen(),
        ),
      ),
      GoRoute(
        path: '/chat/:id',
        name: 'chat',
        builder: (context, state) {
          final conversacionId = state.pathParameters['id']!;
          final extras = state.extra as Map<String, dynamic>? ?? {};
          return BlocProvider(
            create: (_) => sl<ChatBloc>(),
            child: ChatScreen(
              conversacionId: conversacionId,
              nombreDestino: extras['nombreDestino'] ?? 'Desconocido',
              otroUsuarioId: extras['otroUsuarioId'] ?? '',
            ),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Página no encontrada',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}
