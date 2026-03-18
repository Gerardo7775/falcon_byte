import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Pantalla principal — Diseño Premium
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _activeBannerIndex = 0;
  int _activeChipIndex = -1;
  final PageController _pageController = PageController(viewportFraction: 0.92);
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = context.read<AuthBloc>().state;
    final nombre = authState is AuthAuthenticated
        ? authState.usuario.nombre.split(' ').first
        : 'Estudiante';

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) context.go('/login');
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        extendBody: true,
        body: CustomScrollView(
          slivers: [
            // ── Header con gradiente ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0A1628), Color(0xFF0D2F5E)],
                        )
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.gradientStart,
                            AppColors.gradientMid
                          ],
                        ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hola, $nombre 👋',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '¿Qué buscas hoy?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Avatar del perfil
                        GestureDetector(
                          onTap: () => context.push('/perfil'),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                            child: const Icon(Icons.person_rounded,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Barra de búsqueda ────────────────────────────────────
                    _SearchBar(isDark: isDark),
                    const SizedBox(height: 16),

                    // ── Chips de filtro ──────────────────────────────────────
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'Favoritos',
                            icon: Icons.favorite_rounded,
                            isActive: _activeChipIndex == 0,
                            onTap: () => setState(() => _activeChipIndex =
                                _activeChipIndex == 0 ? -1 : 0),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Historial',
                            icon: Icons.history_rounded,
                            isActive: _activeChipIndex == 1,
                            onTap: () => setState(() => _activeChipIndex =
                                _activeChipIndex == 1 ? -1 : 1),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Seguidos',
                            icon: Icons.person_add_rounded,
                            isActive: _activeChipIndex == 2,
                            onTap: () => setState(() => _activeChipIndex =
                                _activeChipIndex == 2 ? -1 : 2),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Menú',
                            icon: Icons.restaurant_menu_rounded,
                            isActive: _activeChipIndex == 3,
                            onTap: () => setState(() => _activeChipIndex =
                                _activeChipIndex == 3 ? -1 : 3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Banner Promocional ───────────────────────────────────
                    SizedBox(
                      height: 168,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (p) =>
                            setState(() => _activeBannerIndex = p),
                        children: const [
                          _PromoBanner(
                              title: 'Menú del Día',
                              subtitle: 'Cafetería Central',
                              emoji: '🍔',
                              colorA: Color(0xFF1A3A6B),
                              colorB: Color(0xFF0D7BE0)),
                          _PromoBanner(
                              title: 'Kioscos',
                              subtitle: 'Snacks & Bebidas',
                              emoji: '☕',
                              colorA: Color(0xFF7C3C1A),
                              colorB: Color(0xFFD45B1C)),
                          _PromoBanner(
                              title: 'Mercado Local',
                              subtitle: 'Productos frescos',
                              emoji: '🌿',
                              colorA: Color(0xFF1A5C2E),
                              colorB: Color(0xFF22C55E)),
                          _PromoBanner(
                              title: 'Postres & Dulces',
                              subtitle: 'Antojos del día',
                              emoji: '🍰',
                              colorA: Color(0xFF6B1A5A),
                              colorB: Color(0xFFD946EF)),
                        ],
                      ),
                    ),
                    // Dots del banner
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _activeBannerIndex == i ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _activeBannerIndex == i
                                ? AppColors.accent
                                : (isDark ? Colors.white30 : Colors.black26),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Sección Cafetería ────────────────────────────────────
                    _SectionHeader(title: 'Cafetería Tec', isDark: isDark),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProductCard(
                            imageUrl:
                                'https://picsum.photos/seed/burger/300/300',
                            brand: 'Cafetería Central',
                            title: 'Hamburguesa Clásica',
                            price: '\$45',
                            isDark: isDark,
                          ),
                          const SizedBox(width: 14),
                          _ProductCard(
                            imageUrl:
                                'https://picsum.photos/seed/torta/300/300',
                            brand: 'Kiosco Principal',
                            title: 'Torta de Jamón',
                            price: '\$35',
                            isDark: isDark,
                          ),
                          const SizedBox(width: 14),
                          _ProductCard(
                            imageUrl:
                                'https://picsum.photos/seed/sandwich/300/300',
                            brand: 'Cafetería Norte',
                            title: 'Sándwich de Pollo',
                            price: '\$40',
                            isDark: isDark,
                          ),
                          const SizedBox(width: 14),
                          _ProductCard(
                            imageUrl:
                                'https://picsum.photos/seed/pasta/300/300',
                            brand: 'Cafetería Sur',
                            title: 'Pasta al Pesto',
                            price: '\$50',
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Sección Mercado ──────────────────────────────────────
                    _SectionHeader(title: 'Mercado Local', isDark: isDark),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _CircleItem(
                              label: 'Frutas',
                              imageUrl:
                                  'https://picsum.photos/seed/frutas/200/200',
                              isDark: isDark),
                          const SizedBox(width: 16),
                          _CircleItem(
                              label: 'Ramos',
                              imageUrl:
                                  'https://picsum.photos/seed/ramos/200/200',
                              isDark: isDark),
                          const SizedBox(width: 16),
                          _CircleItem(
                              label: 'Postres',
                              imageUrl:
                                  'https://picsum.photos/seed/postres/200/200',
                              isDark: isDark),
                          const SizedBox(width: 16),
                          _CircleItem(
                              label: 'Peras',
                              imageUrl:
                                  'https://picsum.photos/seed/peras/200/200',
                              isDark: isDark),
                          const SizedBox(width: 16),
                          _CircleItem(
                              label: 'Jugos',
                              imageUrl:
                                  'https://picsum.photos/seed/juice/200/200',
                              isDark: isDark),
                        ],
                      ),
                    ),
                    // Espacio para la navbar flotante
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── NavigationBar Material 3 ─────────────────────────────────────────
        bottomNavigationBar: _GlassNavBar(
          currentIndex: _currentIndex,
          isDark: isDark,
          onDestinationSelected: (index) {
            if (index == 2) {
              context.push('/conversaciones');
            } else if (index == 4) {
              context.push('/perfil');
            } else {
              setState(() => _currentIndex = index);
            }
          },
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  WIDGETS AUXILIARES
// ══════════════════════════════════════════════════════════════════════════════

class _GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isDark;
  final ValueChanged<int> onDestinationSelected;

  const _GlassNavBar({
    required this.currentIndex,
    required this.isDark,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F1623).withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: AppColors.accent.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.accent),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded, color: AppColors.accent),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon:
                Icon(Icons.chat_bubble_rounded, color: AppColors.accent),
            label: 'Mensajes',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon:
                Icon(Icons.notifications_rounded, color: AppColors.accent),
            label: 'Notificaciones',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.accent),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final bool isDark;
  const _SearchBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : const Color(0xFFE2E8F4),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search_rounded,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              size: 20),
          const SizedBox(width: 10),
          Text(
            'Buscar productos, cafeterías...',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientMid],
                )
              : null,
          color: isActive
              ? null
              : (isDark ? AppColors.surfaceVariantDark : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFDDE3F0)),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: isActive
                    ? Colors.white
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight)),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? Colors.white
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final Color colorA;
  final Color colorB;

  const _PromoBanner({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.colorA,
    required this.colorB,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorA, colorB],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorA.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Emoji decorativo grande
          Positioned(
            right: -10,
            bottom: -8,
            child: Text(emoji, style: const TextStyle(fontSize: 90, height: 1)),
          ),
          // Textos
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Ver más →',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const Spacer(),
        const Text(
          'Ver todo',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 2),
        const Icon(Icons.chevron_right_rounded,
            size: 18, color: AppColors.accent),
      ],
    );
  }
}

class _ProductCard extends StatefulWidget {
  final String imageUrl;
  final String brand;
  final String title;
  final String price;
  final bool isDark;

  const _ProductCard({
    required this.imageUrl,
    required this.brand,
    required this.title,
    required this.price,
    required this.isDark,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: 155,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen con badge de precio
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      widget.imageUrl,
                      height: 155,
                      width: 155,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 155,
                        color: AppColors.surfaceVariantLight,
                        child: const Icon(Icons.fastfood, size: 40),
                      ),
                    ),
                  ),
                  // Badge de precio
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.gradientStart,
                            AppColors.gradientMid
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        widget.price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.brand,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: widget.isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleItem extends StatefulWidget {
  final String label;
  final String imageUrl;
  final bool isDark;

  const _CircleItem({
    required this.label,
    required this.imageUrl,
    required this.isDark,
  });

  @override
  State<_CircleItem> createState() => _CircleItemState();
}

class _CircleItemState extends State<_CircleItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 130),
        child: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gradientMid, AppColors.gradientEnd],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: ClipOval(
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.shopping_basket,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: widget.isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
