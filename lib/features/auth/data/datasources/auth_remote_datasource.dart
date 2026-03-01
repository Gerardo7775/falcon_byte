import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/usuario_model.dart';

/// Data source remoto — solo autenticación con Microsoft
abstract class AuthRemoteDataSource {
  Future<UsuarioModel> loginConMicrosoft();
  Future<void> logout();
  Future<UsuarioModel?> obtenerUsuarioActual();
  Stream<UsuarioModel?> get estadoAuth;
  Future<UsuarioModel> actualizarPerfil({
    required String userId,
    String? nombre,
    String? telefono,
    String? fotoUrl,
  });
  Future<List<UsuarioModel>> buscarUsuariosPorNombre(String query);
  Future<UsuarioModel?> obtenerUsuarioPorId(String id);
}

/// Implementación del data source remoto
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UsuarioModel> loginConMicrosoft() async {
    try {
      // En Android, instanciar usando OAuthProvider explícito asegura que
      // no se inicialice indebidamente el estado de web ni fallen los custom tabs.
      // Construcción estándar de MicrosoftAuthProvider.
      // Ya no forzamos 'tenant' ni 'prompt' a nivel código porque el AppId
      // de Azure AD registrado como "Soporte Multi-Inquilino" (Cuentas Personales o de Institución)
      // choca cuando le inyectamos Single-Tenant parameters aquí en Flutter mobile (Error de Initial State).
      final microsoftProvider = MicrosoftAuthProvider();

      // Al ser Single-Tenant en Azure, debemos mandar el ID forzosamente.
      microsoftProvider.setCustomParameters({
        'tenant': '5a8a2a25-21aa-42e8-9b84-299dd9577ced',
      });

      // Firebase SignIn: En Android esto lanza Chrome Custom Tabs.
      // Si Chrome particiona el State (Missing Initial State error), se hace doble login.
      final userCredential =
          await firebaseAuth.signInWithProvider(microsoftProvider);

      if (userCredential.user == null) {
        throw const AuthException('No se pudo iniciar sesión con Microsoft');
      }

      final user = userCredential.user!;

      final docRef =
          firestore.collection(AppConstants.usuariosCollection).doc(user.uid);
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.update({'fechaActualizacion': Timestamp.now()});
        return UsuarioModel.fromFirestore(doc);
      }

      // Usuario nuevo — crear documento en Firestore
      final usuario = UsuarioModel(
        id: user.uid,
        nombre:
            user.displayName ?? user.email?.split('@').first ?? 'Estudiante',
        email: user.email!,
        telefono: user.phoneNumber,
        fotoUrl: user.photoURL,
        esVendedor: false,
        fechaRegistro: DateTime.now(),
      );

      await docRef.set(usuario.toJson());
      return usuario;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getMicrosoftErrorMessage(e.code));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UsuarioModel?> obtenerUsuarioActual() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;

      final doc = await firestore
          .collection(AppConstants.usuariosCollection)
          .doc(user.uid)
          .get();

      if (!doc.exists) return null;
      return UsuarioModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<UsuarioModel?> get estadoAuth {
    return firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      final doc = await firestore
          .collection(AppConstants.usuariosCollection)
          .doc(user.uid)
          .get();

      if (!doc.exists) return null;
      return UsuarioModel.fromFirestore(doc);
    });
  }

  @override
  Future<UsuarioModel> actualizarPerfil({
    required String userId,
    String? nombre,
    String? telefono,
    String? fotoUrl,
  }) async {
    try {
      final updates = <String, dynamic>{'fechaActualizacion': Timestamp.now()};
      if (nombre != null) updates['nombre'] = nombre;
      if (telefono != null) updates['telefono'] = telefono;
      if (fotoUrl != null) updates['fotoUrl'] = fotoUrl;

      final docRef =
          firestore.collection(AppConstants.usuariosCollection).doc(userId);

      await docRef.update(updates);
      final doc = await docRef.get();
      return UsuarioModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Helper para remover acentos y diacríticos de strings
  String _quitarAcentos(String texto) {
    const conAcento =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const sinAcento =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    String resultado = texto;
    for (int i = 0; i < conAcento.length; i++) {
      resultado = resultado.replaceAll(conAcento[i], sinAcento[i]);
    }
    return resultado;
  }

  @override
  Future<List<UsuarioModel>> buscarUsuariosPorNombre(String query) async {
    try {
      final String searchQuery = _quitarAcentos(query.trim().toLowerCase());
      if (searchQuery.isEmpty) return [];

      // Como Firebase no soporta consultas "LIKE %query%" nativas (búsqueda de subcadenas intermedias),
      // bajamos todos los usuarios (ideal para MVPs o apps institucionales de pocos miles de usuarios)
      // y filtramos en RAM para permitir búsquedas ignorando mayúsculas/minúsculas y acentos.
      final querySnapshot =
          await firestore.collection(AppConstants.usuariosCollection).get();

      final todosLosUsuarios = querySnapshot.docs
          .map((doc) => UsuarioModel.fromFirestore(doc))
          .toList();

      // Filtro local: que el nombre normalizado contenga la cadena buscada normalizada
      final filtrados = todosLosUsuarios.where((u) {
        final nombreNormalizado = _quitarAcentos(u.nombre.toLowerCase());
        return nombreNormalizado.contains(searchQuery);
      }).toList();

      // Devolvemos solo los primeros 20 para no saturar memoria UI si hay muchos
      return filtrados.take(20).toList();
    } catch (e) {
      throw ServerException('Error al buscar usuarios: $e');
    }
  }

  @override
  Future<UsuarioModel?> obtenerUsuarioPorId(String id) async {
    try {
      final doc = await firestore
          .collection(AppConstants.usuariosCollection)
          .doc(id)
          .get();
      if (!doc.exists) return null;
      return UsuarioModel.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  String _getMicrosoftErrorMessage(String code) {
    switch (code) {
      case 'popup-closed-by-user':
        return 'Inicio de sesión cancelado';
      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con ese correo usando otro método';
      case 'user-disabled':
        return 'Tu cuenta ha sido deshabilitada';
      case 'cancelled-popup-request':
        return 'Inicio de sesión cancelado';
      default:
        return 'Error ($code): Intenta de nuevo.';
    }
  }
}
