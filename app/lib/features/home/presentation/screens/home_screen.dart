import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Pantalla principal
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _activeBannerIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.92);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('FalconByte',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () => context.push('/perfil'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra de búsqueda
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Chips de Filtrado (Scroll horizontal)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildChip('Favoritos', Icons.favorite_border),
                    const SizedBox(width: 8),
                    _buildChip('Historial', Icons.history),
                    const SizedBox(width: 8),
                    _buildChip('Seguidos', Icons.person_outline),
                    const SizedBox(width: 8),
                    _buildChip('Menú', Icons.restaurant_menu),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Banner Promocional Deslizable
              SizedBox(
                height: 155,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _activeBannerIndex = page;
                    });
                  },
                  children: [
                    _buildPromoBanner('Menú del Día',
                        'https://picsum.photos/seed/menu/400/200', 0),
                    _buildPromoBanner('Productos de Kiosco',
                        'https://picsum.photos/seed/kiosco/400/200', 1),
                    _buildPromoBanner('Más de Cafetería',
                        'https://picsum.photos/seed/cafe/400/200', 2),
                    _buildPromoBanner('Mercado Local',
                        'https://picsum.photos/seed/mercado/400/200', 3),
                    _buildPromoBanner('Otros Productos',
                        'https://picsum.photos/seed/otros/400/200', 4),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sección: Cafetería Tec
              _buildSectionTitle('Cafetería Tec'),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductCard(
                      imageUrl: 'https://picsum.photos/seed/burger/200/200',
                      brand: 'Cafetería Central',
                      title: 'Hamburguesa clásica',
                      price: '\$45.00',
                    ),
                    const SizedBox(width: 16),
                    _buildProductCard(
                      imageUrl: 'https://picsum.photos/seed/torta/200/200',
                      brand: 'Kiosco',
                      title: 'Torta de Jamón',
                      price: '\$35.00',
                    ),
                    const SizedBox(width: 16),
                    _buildProductCard(
                      imageUrl: 'https://picsum.photos/seed/sandwich/200/200',
                      brand: 'Cafetería Norte',
                      title: 'Sándwich de Pollo',
                      price: '\$40.00',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sección: Mercado Local
              _buildSectionTitle('Mercado Local'),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCircleItem(
                        'Peras', 'https://picsum.photos/seed/peras/200/200'),
                    const SizedBox(width: 16),
                    _buildCircleItem(
                        'Fruta', 'https://picsum.photos/seed/frutas/200/200'),
                    const SizedBox(width: 16),
                    _buildCircleItem(
                        'Ramos', 'https://picsum.photos/seed/ramos/200/200'),
                    const SizedBox(width: 16),
                    _buildCircleItem('Postres',
                        'https://picsum.photos/seed/postres/200/200'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 2) {
              context.push('/conversaciones');
            } else if (index == 4) {
              context.push('/perfil');
            } else {
              setState(() => _currentIndex = index);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 28), label: 'Inicio'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined, size: 28),
                label: 'Explorar'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline, size: 28),
                label: 'Mensajes'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined, size: 28),
                label: 'Notificaciones'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 28), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner(String title, String imageUrl, int pageIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 6), // Separación para el peeking
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: -10,
            bottom: -10,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 50,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 5; i++) _buildDot(i == _activeBannerIndex),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: isActive ? 6 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.black87 : Colors.black26,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.chevron_right, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildProductCard(
      {required String imageUrl,
      required String brand,
      required String title,
      required String price}) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(brand,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(price,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCircleItem(String title, String imageUrl) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }
}
