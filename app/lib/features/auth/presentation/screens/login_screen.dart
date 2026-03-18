import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import '../bloc/auth_bloc.dart';

/// Pantalla de login — Solo acceso institucional con Microsoft
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late Animation<double> _pulseAnim;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _floatAnim = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // ── Fondo con gradiente animado ─────────────────────────────────────
          AnimatedBuilder(
            animation: _gradientController,
            builder: (_, __) {
              final t = _gradientController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + t * 0.6, -1),
                    end: Alignment(1 - t * 0.6, 1),
                    colors: isDark
                        ? [
                            const Color(0xFF070C16),
                            Color.lerp(const Color(0xFF0A1F45),
                                const Color(0xFF0D2F5E), t)!,
                            const Color(0xFF030810),
                          ]
                        : [
                            Color.lerp(const Color(0xFFE8F0FA),
                                const Color(0xFFF0F6FF), t)!,
                            const Color(0xFFFFFFFF),
                            Color.lerp(const Color(0xFFDBEBFF),
                                const Color(0xFFE8F4FF), t)!,
                          ],
                  ),
                ),
              );
            },
          ),

          // ── Partículas decorativas ──────────────────────────────────────────
          if (isDark) ..._buildParticles(),

          // ── Contenido ──────────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Toggle de tema
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12, top: 4),
                    child: ValueListenableBuilder<ThemeMode>(
                      valueListenable: themeModeNotifier,
                      builder: (_, mode, __) {
                        final isCurrentlyDark = mode == ThemeMode.dark ||
                            (mode == ThemeMode.system &&
                                MediaQuery.platformBrightnessOf(context) ==
                                    Brightness.dark);
                        return IconButton(
                          tooltip:
                              isCurrentlyDark ? 'Modo claro' : 'Modo oscuro',
                          icon: Icon(
                            isCurrentlyDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                          onPressed: () {
                            themeModeNotifier.value = isCurrentlyDark
                                ? ThemeMode.light
                                : ThemeMode.dark;
                          },
                        );
                      },
                    ),
                  ),
                ),

                Expanded(
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(child: Text(state.message)),
                            ]),
                            backgroundColor: AppColors.error,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        );
                      } else if (state is AuthAuthenticated) {
                        context.go('/home');
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ── Logo animado ──────────────────────────────
                              AnimatedBuilder(
                                animation: _floatAnim,
                                builder: (_, child) => Transform.translate(
                                  offset: Offset(0, _floatAnim.value),
                                  child: child,
                                ),
                                child: AnimatedBuilder(
                                  animation: _pulseAnim,
                                  builder: (_, child) => Transform.scale(
                                    scale: _pulseAnim.value,
                                    child: child,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Anillo exterior pulsante
                                      Container(
                                        width: 112,
                                        height: 112,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              AppColors.accent.withValues(
                                                  alpha: isDark ? 0.25 : 0.15),
                                              AppColors.accent
                                                  .withValues(alpha: 0),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Ícono principal
                                      Container(
                                        width: 88,
                                        height: 88,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppColors.gradientMid,
                                              AppColors.gradientEnd,
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.accent
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 24,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text('🦅',
                                              style: TextStyle(fontSize: 42)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),

                              // ── Título ────────────────────────────────────
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    AppGradients.accent.createShader(bounds),
                                blendMode: BlendMode.srcIn,
                                child: Text(
                                  'FalconByte',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Plataforma exclusiva del\nTecNM Campus Toluca',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 44),

                              // ── Card de login con glassmorphism ───────────
                              _GlassCard(
                                isDark: isDark,
                                child: Column(
                                  children: [
                                    Text(
                                      'Bienvenido',
                                      style: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Inicia sesión con tu cuenta institucional\npara acceder a la plataforma.',
                                      textAlign: TextAlign.center,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        height: 1.6,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 28),

                                    // ── Botón Microsoft con gradiente ─────
                                    AnimatedOpacity(
                                      opacity: isLoading ? 0.6 : 1.0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: SizedBox(
                                        height: 56,
                                        width: double.infinity,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            gradient: isLoading
                                                ? null
                                                : const LinearGradient(
                                                    colors: [
                                                      AppColors.gradientStart,
                                                      AppColors.gradientMid,
                                                    ],
                                                  ),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            boxShadow: isLoading
                                                ? null
                                                : [
                                                    BoxShadow(
                                                      color: AppColors.primary
                                                          .withValues(
                                                              alpha: 0.4),
                                                      blurRadius: 16,
                                                      offset:
                                                          const Offset(0, 6),
                                                    ),
                                                  ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: isLoading
                                                ? null
                                                : () => context
                                                    .read<AuthBloc>()
                                                    .add(LoginMicrosoftEvent()),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                            child: isLoading
                                                ? const SizedBox(
                                                    width: 22,
                                                    height: 22,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      _MicrosoftLogo(),
                                                      const SizedBox(width: 14),
                                                      const Text(
                                                        'Continuar con Microsoft',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // ── Nota de privacidad ────────────────────────
                              Text(
                                'Al continuar, aceptas los Términos de Servicio\ny la Política de Privacidad de FalconByte.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildParticles() {
    final positions = [
      const Offset(0.1, 0.15),
      const Offset(0.85, 0.1),
      const Offset(0.7, 0.4),
      const Offset(0.15, 0.6),
      const Offset(0.9, 0.65),
      const Offset(0.4, 0.85),
    ];
    final sizes = [4.0, 3.0, 5.0, 3.0, 4.0, 3.0];
    return List.generate(positions.length, (i) {
      return AnimatedBuilder(
        animation: _gradientController,
        builder: (_, __) {
          final t = ((_gradientController.value + i * 0.15) % 1.0);
          final opacity = (math.sin(t * math.pi)).clamp(0.1, 0.6);
          return Positioned(
            left: MediaQuery.sizeOf(context).width * positions[i].dx,
            top: MediaQuery.sizeOf(context).height * positions[i].dy +
                math.sin(t * math.pi * 2) * 8,
            child: Opacity(
              opacity: opacity,
              child: Container(
                width: sizes[i],
                height: sizes[i],
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentVibrant,
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

/// Card con efecto glassmorphism
class _GlassCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const _GlassCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F1825).withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
          if (!isDark)
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: child,
    );
  }
}

/// Logo de Microsoft
class _MicrosoftLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Column(children: [
        Row(children: [
          _Quad(Colors.red.shade400),
          const SizedBox(width: 2),
          _Quad(Colors.green.shade500),
        ]),
        const SizedBox(height: 2),
        Row(children: [
          _Quad(Colors.blue.shade400),
          const SizedBox(width: 2),
          _Quad(Colors.yellow.shade600),
        ]),
      ]),
    );
  }
}

class _Quad extends StatelessWidget {
  final Color color;
  const _Quad(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(width: 9, height: 9, color: color);
  }
}
