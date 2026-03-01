import 'package:equatable/equatable.dart';

/// Entity de Usuario - Capa de dominio
class UsuarioEntity extends Equatable {
  final String id;
  final String nombre;
  final String email;
  final String? telefono;
  final String? fotoUrl;
  final bool esVendedor;
  final DateTime fechaRegistro;
  final DateTime? fechaActualizacion;

  const UsuarioEntity({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    this.fotoUrl,
    required this.esVendedor,
    required this.fechaRegistro,
    this.fechaActualizacion,
  });

  @override
  List<Object?> get props => [
        id,
        nombre,
        email,
        telefono,
        fotoUrl,
        esVendedor,
        fechaRegistro,
        fechaActualizacion,
      ];

  /// Copia con modificaciones
  UsuarioEntity copyWith({
    String? id,
    String? nombre,
    String? email,
    String? telefono,
    String? fotoUrl,
    bool? esVendedor,
    DateTime? fechaRegistro,
    DateTime? fechaActualizacion,
  }) {
    return UsuarioEntity(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      esVendedor: esVendedor ?? this.esVendedor,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}
