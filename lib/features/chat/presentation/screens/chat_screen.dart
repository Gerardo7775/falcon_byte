import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/chat/chat_event.dart';
import '../bloc/chat/chat_state.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String conversacionId;
  final String nombreDestino;
  final String otroUsuarioId;

  const ChatScreen({
    super.key,
    required this.conversacionId,
    required this.nombreDestino,
    required this.otroUsuarioId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _mensajeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String miId;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      miId = authState.usuario.id;
      // Iniciar el stream veloz de Realtime Database al entrar a la sala
      context
          .read<ChatBloc>()
          .add(IniciarChatStreamEvent(widget.conversacionId));
      // Marcar lo que ya estaba como visualizado cruzando nuestro ID de lectura
      context.read<ChatBloc>().add(MarcarComoLeidosEvent(
          conversacionId: widget.conversacionId, miId: miId));
    }
  }

  @override
  void dispose() {
    _mensajeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _enviarMensaje() {
    final texto = _mensajeController.text.trim();
    if (texto.isEmpty) return;

    context.read<ChatBloc>().add(
          EnviarMensajeEvent(
            conversacionId: widget.conversacionId,
            senderId: miId,
            texto: texto,
          ),
        );
    _mensajeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              child: Icon(Icons.person, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.nombreDestino,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  // Marcar leídos instantáneamente si se tiene abierto
                  context.read<ChatBloc>().add(MarcarComoLeidosEvent(
                      conversacionId: widget.conversacionId, miId: miId));
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatError) {
                  return Center(child: Text(state.mensaje));
                }
                if (state is ChatLoaded) {
                  final mensajes = state.mensajes;

                  if (mensajes.isEmpty) {
                    return const Center(
                      child: Text('Di Hola para iniciar el chat 👋',
                          style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return ListView.builder(
                    reverse:
                        true, // Importante: como la lista viene descendente de Firebase, muestra los nuevos abajo
                    controller: _scrollController,
                    itemCount: mensajes.length,
                    itemBuilder: (context, index) {
                      final msg = mensajes[index];
                      return MessageBubble(
                        key: ValueKey(msg.id),
                        mensaje: msg,
                        isMe: msg.senderId == miId,
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          _buildInputArea(context),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.grey),
              onPressed: () {}, // Para subir imágenes después si se desea
            ),
            Expanded(
              child: TextField(
                controller: _mensajeController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _enviarMensaje,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
