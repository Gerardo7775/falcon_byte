import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/usuario_entity.dart';

/// Modelo de Usuario para Firebase - Capa de datos
class UsuarioModel extends UsuarioEntity {
  const UsuarioModel({
    required super.id,
    required super.nombre,
    required super.email,
    super.telefono,
    super.fotoUrl,
    required super.esVendedor,
    required super.fechaRegistro,
    super.fechaActualizacion,
  });

  /// Crear desde JSON
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      fotoUrl: json['fotoUrl'] as String?,
      esVendedor: json['esVendedor'] as bool? ?? false,
      fechaRegistro: json['fechaRegistro'] is Timestamp
          ? (json['fechaRegistro'] as Timestamp).toDate()
          : DateTime.parse(json['fechaRegistro'] as String),
      fechaActualizacion: json['fechaActualizacion'] != null
          ? (json['fechaActualizacion'] is Timestamp
              ? (json['fechaActualizacion'] as Timestamp).toDate()
              : DateTime.parse(json['fechaActualizacion'] as String))
          : null,
    );
  }

  /// Crear desde Firestore DocumentSnapshot
  factory UsuarioModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UsuarioModel.fromJson({'id': doc.id, ...data});
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'fotoUrl': fotoUrl,
      'esVendedor': esVendedor,
      'fechaRegistro': Timestamp.fromDate(fechaRegistro),
      'fechaActualizacion': fechaActualizacion != null
          ? Timestamp.fromDate(fechaActualizacion!)
          : null,
    };
  }

  /// Convertir a Entity
  UsuarioEntity toEntity() {
    return UsuarioEntity(
      id: id,
      nombre: nombre,
      email: email,
      telefono: telefono,
      fotoUrl: fotoUrl,
      esVendedor: esVendedor,
      fechaRegistro: fechaRegistro,
      fechaActualizacion: fechaActualizacion,
    );
  }

  /// Crear desde Entity
  factory UsuarioModel.fromEntity(UsuarioEntity entity) {
    return UsuarioModel(
      id: entity.id,
      nombre: entity.nombre,
      email: entity.email,
      telefono: entity.telefono,
      fotoUrl: entity.fotoUrl,
      esVendedor: entity.esVendedor,
      fechaRegistro: entity.fechaRegistro,
      fechaActualizacion: entity.fechaActualizacion,
    );
  }
}
