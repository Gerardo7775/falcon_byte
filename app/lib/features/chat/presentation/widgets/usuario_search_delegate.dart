import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/domain/entities/usuario_entity.dart';
import '../../../auth/domain/usecases/buscar_usuarios_usecase.dart';
import '../../domain/usecases/iniciar_conversacion_usecase.dart';

class UsuarioSearchDelegate extends SearchDelegate<UsuarioEntity?> {
  final String miPropioId;
  final BuscarUsuariosUseCase _buscarUsuariosUseCase =
      sl<BuscarUsuariosUseCase>();
  final IniciarConversacionUseCase _iniciarConversacionUseCase =
      sl<IniciarConversacionUseCase>();

  UsuarioSearchDelegate({required this.miPropioId})
      : super(searchFieldLabel: 'Nombre del estudiante...');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultados(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search,
                size: 80, color: Colors.grey.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text('Busca alumnos o profesores por nombre',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return _buildResultados(context);
  }

  Widget _buildResultados(BuildContext context) {
    return FutureBuilder(
      future: _buscarUsuariosUseCase(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final result = snapshot.data;
        if (result == null) return const SizedBox.shrink();

        return result.fold(
          (failure) =>
              Center(child: Text('Falló la búsqueda: ${failure.message}')),
          (usuarios) {
            // Quitamos a nosotros mismos de la lista de resultados usando .where
            final filtrados =
                usuarios.where((u) => u.id != miPropioId).toList();

            if (filtrados.isEmpty) {
              return const Center(
                  child: Text('No hubieron coincidencias exactas.'));
            }

            return ListView.builder(
              itemCount: filtrados.length,
              itemBuilder: (context, index) {
                final usuario = filtrados[index];
                return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      child: Text(usuario.nombre.substring(0, 1).toUpperCase(),
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                    title: Text(usuario.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing:
                        const Icon(Icons.maps_ugc_rounded, color: Colors.grey),
                    onTap: () async {
                      // Muestra UI Bloqueante
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()));

                      try {
                        final chatRecord = await _iniciarConversacionUseCase(
                            miPropioId, usuario.id);
                        if (context.mounted) {
                          Navigator.pop(context); // Quita el loader
                          close(context,
                              usuario); // Cierra el delegado de busqueda
                          // Abre la pantalla del chat
                          context.push('/chat/$chatRecord', extra: {
                            'otroUsuarioId': usuario.id,
                            'nombreDestino': usuario.nombre
                          });
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(context); // Quita el loader
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Error creando la sala: $e')));
                        }
                      }
                    });
              },
            );
          },
        );
      },
    );
  }
}
