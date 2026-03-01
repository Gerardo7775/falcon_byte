/// Constantes de la aplicación
class AppConstants {
  // Nombre de la aplicación
  static const String appName = 'FalconByte';

  // Colecciones de Firestore
  static const String usuariosCollection = 'usuarios';
  static const String productosCollection = 'productos';
  static const String pedidosCollection = 'pedidos';
  static const String quioscosCollection = 'quioscos';
  static const String publicacionesCollection = 'publicaciones';
  static const String conversacionesCollection = 'conversaciones';

  // Realtime Database paths
  static const String mensajesPath = 'mensajes';

  // Storage paths
  static const String productosImagenesPath = 'productos';
  static const String perfilesImagenesPath = 'perfiles';

  // Categorías
  static const List<String> categoriasCafeteria = [
    'Desayuno',
    'Comida',
    'Cena',
    'Bebidas',
    'Postres',
    'Snacks',
  ];

  static const List<String> categoriasMercado = [
    'Comida',
    'Bebidas',
    'Snacks',
    'Postres',
    'Artesanías',
    'Servicios',
    'Otros',
  ];

  // Ubicaciones del Tec
  static const List<String> ubicacionesTec = [
    'Edificio A',
    'Edificio B',
    'Edificio C',
    'Edificio D',
    'Edificio E',
    'Edificio F',
    'Edificio G',
    'Edificio H',
    'Edificio I',
    'Edificio J',
    'Edificio K',
    'Edificio L',
    'Edificio M',
    'Edificio N',
    'Edificio O',
    'Edificio P',
    'Edificio Q',
    'Edificio R',
    'Edificio S',
    'Edificio T',
    'Cafetería Central',
    'Biblioteca',
    'Gimnasio',
    'Auditorio',
  ];

  // Métodos de pago
  static const List<String> metodosPago = ['Efectivo', 'Tarjeta'];
}
