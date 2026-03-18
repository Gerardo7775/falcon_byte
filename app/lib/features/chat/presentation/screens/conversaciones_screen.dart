// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // ── AppBar con gradiente ─────────────────────────────────────────────
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
                    onPressed: () => context.pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Mensajes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  _GlassIconButton(
                    icon: Icons.search_rounded,
                    onTap: () {
                      if (mounted) {
                        showSearch(
                          context: context,
                          delegate: UsuarioSearchDelegate(miPropioId: miId),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),

      body: BlocBuilder<ConversacionesBloc, ConversacionesState>(
        builder: (context, state) {
          if (state is ConversacionesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.accent,
              ),
            );
          }
          if (state is ConversacionesError) {
            return Center(child: Text('Error: ${state.mensaje}'));
          }
          if (state is ConversacionesLoaded) {
            final chats = state.conversaciones;

            if (chats.isEmpty) {
              return _EmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 20),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 200 + index * 60),
                  curve: Curves.easeOut,
                  builder: (_, value, child) => Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  ),
                  child: _ChatTile(chat: chats[index], miId: miId),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),

      // ── FAB con gradiente ─────────────────────────────────────────────────
      floatingActionButton: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.gradientMid, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 24),
          onPressed: () {
            showSearch(
              context: context,
              delegate: UsuarioSearchDelegate(miPropioId: miId),
            );
          },
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _EmptyState extends StatefulWidget {
  @override
  State<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<_EmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _anim,
            builder: (_, child) =>
                Transform.scale(scale: _anim.value, child: child),
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.gradientMid, AppColors.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sin mensajes aún',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón para iniciar\nuna nueva conversación',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  CHAT TILE
// ══════════════════════════════════════════════════════════════════════════════

class _ChatTile extends StatefulWidget {
  final dynamic chat;
  final String miId;
  const _ChatTile({required this.chat, required this.miId});

  @override
  State<_ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<_ChatTile> {
  String _displayName = '...';
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
          (u) => _displayName = u?.nombre ?? 'Usuario Desconocido',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ultimoMensaje = widget.chat.ultimoMensaje;
    final tieneNuevos = ultimoMensaje != null &&
        !ultimoMensaje.leido &&
        ultimoMensaje.senderId != widget.miId;

    final avatarColor = AppColors.avatarColorFor(_displayName);
    final initial =
        _displayName.isNotEmpty ? _displayName[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            context.push('/chat/${widget.chat.id}', extra: {
              'otroUsuarioId': _otroId,
              'nombreDestino': _displayName
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceVariantDark.withValues(alpha: 0.6)
                  : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: tieneNuevos
                    ? AppColors.accent.withValues(alpha: 0.4)
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFEEF2F8)),
                width: tieneNuevos ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar con color único
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        avatarColor,
                        avatarColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: avatarColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayName,
                        style: TextStyle(
                          fontWeight:
                              tieneNuevos ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 15,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        ultimoMensaje?.texto ?? 'Inicia una conversación...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: tieneNuevos
                              ? (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight)
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight),
                          fontWeight:
                              tieneNuevos ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Hora + badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (ultimoMensaje != null)
                      Text(
                        _formatearHora(ultimoMensaje.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: tieneNuevos
                              ? AppColors.accent
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight),
                        ),
                      ),
                    const SizedBox(height: 6),
                    if (tieneNuevos)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.gradientMid,
                              AppColors.gradientEnd
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatearHora(DateTime fecha) {
    return '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }
}
