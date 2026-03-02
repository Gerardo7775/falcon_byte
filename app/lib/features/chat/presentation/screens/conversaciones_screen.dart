// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/domain/usecases/obtener_usuario_por_id_usecase.dart'
    as flutter_di;
import '../../../auth/presentation/bloc/auth_bloc.dart';

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
                return _ChatTile(chat: chats[index], miId: miId);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: UsuarioSearchDelegate(miPropioId: miId),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }
}

class _ChatTile extends StatefulWidget {
  final dynamic chat; // ConversacionEntity
  final String miId;

  const _ChatTile({required this.chat, required this.miId});

  @override
  State<_ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<_ChatTile> {
  String _displayName = 'Cargando...';
  late String _otroId;

  @override
  void initState() {
    super.initState();
    _otroId = widget.chat.participantesIds
        .firstWhere((id) => id != widget.miId, orElse: () => 'Desconocido');
    _cargarNombreDeUsuario();
  }

  Future<void> _cargarNombreDeUsuario() async {
    final useCase = sl<flutter_di.ObtenerUsuarioPorIdUseCase>();
    final result = await useCase(_otroId);
    if (mounted) {
      setState(() {
        result.fold(
          (l) => _displayName = 'Usuario Desconocido',
          (usuario) => _displayName = usuario?.nombre ?? 'Usuario Desconocido',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ultimoMensaje = widget.chat.ultimoMensaje;
    bool tieneNuevos = false;

    if (ultimoMensaje != null &&
        !ultimoMensaje.leido &&
        ultimoMensaje.senderId != widget.miId) {
      tieneNuevos = true;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        child: Icon(Icons.person, color: Theme.of(context).primaryColor),
      ),
      title: Text(
        _displayName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        ultimoMensaje?.texto ?? 'Inicia una conversación...',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: tieneNuevos
              ? Theme.of(context).textTheme.bodyLarge?.color
              : Colors.grey,
          fontWeight: tieneNuevos ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (ultimoMensaje != null)
            Text(
              _formatearHora(ultimoMensaje.timestamp),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          const SizedBox(height: 4),
          if (tieneNuevos)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(width: 8, height: 8),
            )
        ],
      ),
      onTap: () {
        context.push('/chat/${widget.chat.id}',
            extra: {'otroUsuarioId': _otroId, 'nombreDestino': _displayName});
      },
    );
  }

  String _formatearHora(DateTime fecha) {
    return '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}
