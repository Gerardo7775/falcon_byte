import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/mensaje.dart';

class MessageBubble extends StatefulWidget {
  final Mensaje mensaje;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.mensaje,
    required this.isMe,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slideAnim = Tween<Offset>(
      begin: Offset(widget.isMe ? 0.3 : -0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Align(
          alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(
              left: widget.isMe ? 60 : 12,
              right: widget.isMe ? 12 : 60,
              top: 3,
              bottom: 3,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              // Burbujas propias: gradiente diagonal
              gradient: widget.isMe
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2251A3),
                        AppColors.gradientEnd,
                      ],
                    )
                  : null,
              // Burbujas ajenas: surface glass
              color: widget.isMe
                  ? null
                  : (isDark
                      ? AppColors.surfaceVariantDark
                      : Colors.white),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(widget.isMe ? 18 : 4),
                bottomRight: Radius.circular(widget.isMe ? 4 : 18),
              ),
              border: widget.isMe
                  ? null
                  : Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.07)
                          : const Color(0xFFE2E8F4),
                    ),
              boxShadow: [
                BoxShadow(
                  color: widget.isMe
                      ? AppColors.primary.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.mensaje.texto,
                  style: TextStyle(
                    color: widget.isMe
                        ? Colors.white
                        : (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(widget.mensaje.timestamp),
                      style: TextStyle(
                        color: widget.isMe
                            ? Colors.white.withValues(alpha: 0.7)
                            : (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight),
                        fontSize: 11,
                      ),
                    ),
                    if (widget.isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        widget.mensaje.leido ? Icons.done_all_rounded : Icons.check_rounded,
                        size: 14,
                        color: widget.mensaje.leido
                            ? AppColors.accentVibrant.withValues(alpha: 0.9)
                            : Colors.white.withValues(alpha: 0.6),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
