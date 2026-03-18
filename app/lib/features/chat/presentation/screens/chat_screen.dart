import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
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
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      miId = authState.usuario.id;
      context
          .read<ChatBloc>()
          .add(IniciarChatStreamEvent(widget.conversacionId));
      context.read<ChatBloc>().add(MarcarComoLeidosEvent(
          conversacionId: widget.conversacionId, miId: miId));
    }
    _mensajeController.addListener(() {
      final hasText = _mensajeController.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
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
    context.read<ChatBloc>().add(EnviarMensajeEvent(
          conversacionId: widget.conversacionId,
          senderId: miId,
          texto: texto,
        ));
    _mensajeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarColor = AppColors.avatarColorFor(widget.nombreDestino);
    final initial = widget.nombreDestino.isNotEmpty
        ? widget.nombreDestino[0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // ── AppBar con gradiente ───────────────────────────────────────────────
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    colors: [Color(0xFF0A1628), Color(0xFF0D2244)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientMid],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  // Avatar con inicial
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          avatarColor,
                          avatarColor.withValues(alpha: 0.65),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.nombreDestino,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'En línea',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert_rounded,
                        color: Colors.white.withValues(alpha: 0.85)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  context.read<ChatBloc>().add(MarcarComoLeidosEvent(
                      conversacionId: widget.conversacionId, miId: miId));
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.accent));
                }
                if (state is ChatError) {
                  return Center(child: Text(state.mensaje));
                }
                if (state is ChatLoaded) {
                  final mensajes = state.mensajes;
                  if (mensajes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('👋', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            'Di Hola para iniciar el chat',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
          _buildInputArea(isDark),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.97)
            : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE8EDF5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Campo de texto
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceVariantDark
                      : const Color(0xFFF3F6FC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.07)
                        : const Color(0xFFDDE3F0),
                  ),
                ),
                child: TextField(
                  controller: _mensajeController,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Mensaje...',
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.emoji_emotions_outlined,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          size: 22),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Botón de enviar con gradiente y animación
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: _hasText
                    ? const LinearGradient(
                        colors: [AppColors.gradientMid, AppColors.gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: _hasText
                    ? null
                    : (isDark
                        ? AppColors.surfaceVariantDark
                        : const Color(0xFFEAEEF7)),
                shape: BoxShape.circle,
                boxShadow: _hasText
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: IconButton(
                icon: Icon(
                  _hasText ? Icons.send_rounded : Icons.mic_rounded,
                  color: _hasText
                      ? Colors.white
                      : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
                  size: 20,
                ),
                onPressed: _hasText ? _enviarMensaje : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
