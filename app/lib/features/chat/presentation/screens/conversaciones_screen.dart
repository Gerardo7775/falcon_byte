// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/domain/usecases/obtener_usuario_por_id_usecase.dart'
    as flutter_di;
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/usecases/iniciar_conversacion_usecase.dart';
import '../bloc/conversaciones/conversaciones_bloc.dart';
import '../bloc/conversaciones/conversaciones_event.dart';
import '../bloc/conversaciones/conversaciones_state.dart';
import '../widgets/usuario_search_delegate.dart';

class ConversacionesScreen extends StatefulWidget {
  const ConversacionesScreen({super.key});

  @override
  State<ConversacionesScreen> createState() => _ConversacionesScreenState();
}

class _ConversacionesScreenState extends State<ConversacionesScreen> {
  late String miId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      miId = authState.usuario.id;
      context.read<ConversacionesBloc>().add(IniciarStreamConversaciones(miId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes Institucionales'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (mounted) {
                showSearch(
                  context: context,
                  delegate: UsuarioSearchDelegate(miPropioId: miId),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ConversacionesBloc, ConversacionesState>(
        builder: (context, state) {
          if (state is ConversacionesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ConversacionesError) {
            return Center(child: Text('Error: ${state.mensaje}'));
          }
          if (state is ConversacionesLoaded) {
            final chats = state.conversaciones;

            if (chats.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.speaker_notes_off_outlined,
                        size: 80, color: Colors.grey.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    const Text('Aún no tienes mensajes.',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            return ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final chat = chats[index];
                // Encontrar el ID del otro participante (que no soy yo)
                final otroParticipanteId = chat.participantesIds.firstWhere(
                    (id) => id != miId,
                    orElse: () => 'Desconocido');
                final ultimoMensaje = chat.ultimoMensaje;

                // Determinamos si el último mensaje está sin leer (y si me lo mandaron a mí)
                bool tieneNuevos = false;
                if (ultimoMensaje != null &&
                    !ultimoMensaje.leido &&
                    ultimoMensaje.senderId != miId) {
                  tieneNuevos = true;
                }

                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    child: Icon(Icons.person,
                        color: Theme.of(context)
                            .primaryColor), // Ideal sería cargar la foto del perfil
                  ),
                  title: FutureBuilder(
                      future: sl<flutter_di.ObtenerUsuarioPorIdUseCase>()(
                          otroParticipanteId),
                      builder: (context, snapshot) {
                        String displayName = 'Cargando...';
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          snapshot.data!.fold(
                            (l) => displayName = 'Usuario Desconocido',
                            (usuario) =>
                                displayName = usuario?.nombre ?? 'Desconocido',
                          );
                        }
                        return Text(
                          displayName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                  subtitle: Text(
                    ultimoMensaje?.texto ?? 'Inicia una conversación...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: tieneNuevos
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : Colors.grey,
                      fontWeight:
                          tieneNuevos ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (ultimoMensaje != null)
                        Text(
                          _formatearHora(ultimoMensaje.timestamp),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      const SizedBox(height: 4),
                      if (tieneNuevos)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child:
                              const SizedBox(width: 8, height: 8), // un punto
                        )
                    ],
                  ),
                  onTap: () {
                    context.push('/chat/${chat.id}', extra: {
                      'otroUsuarioId': otroParticipanteId,
                      'nombreDestino': 'Usuario $otroParticipanteId'
                    });
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoNuevoChat(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _mostrarDialogoNuevoChat(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Chat'),
        content: TextField(
          controller: idController,
          decoration: InputDecoration(
            hintText: 'Ej. user_123',
            labelText: 'ID del Usuario Institucional',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final otroId = idController.text.trim();
              if (otroId.isEmpty) return;
              Navigator.pop(ctx);

              try {
                // Instanciando On-Demand para no recargar el widget
                final iniciarUseCase = sl<IniciarConversacionUseCase>();
                final chatRecord = await iniciarUseCase(miId, otroId);

                if (mounted) {
                  context.push('/chat/$chatRecord', extra: {
                    'otroUsuarioId': otroId,
                    'nombreDestino': 'Usuario $otroId'
                  });
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No pudimos iniciar el chat: $e')),
                  );
                }
              }
            },
            child: const Text('Iniciar'),
          ),
        ],
      ),
    );
  }

  String _formatearHora(DateTime fecha) {
    return '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}
