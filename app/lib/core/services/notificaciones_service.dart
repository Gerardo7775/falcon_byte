import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

// Este _background_handler_ debe existir COMO FUNCIÓN GLOBAL (Top-Level)
// para que el OS lo pueda despertar cuando el app está minimizada/muerta.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Obligatorio despertar el core
  debugPrint("📩 [FCM Background] Mensaje recibido: ${message.messageId}");
}

class NotificacionesService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    // 1. Pedir permisos (Fundamental en iOS, y Android 13+)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('🔔 FCM Permisos concedidos');
    } else {
      debugPrint('🔇 FCM Permisos denegados');
      return;
    }

    // 2. Imprimir el FCM Token actual (Para debuggear / Mandarlo al user document luego)
    final token = await _fcm.getToken();
    debugPrint('🔔 FCM Token Generado en dispositivo: $token');

    // 3. Configurar Android Local Notifications (Para Foreground Pushes)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _localNotificationsPlugin.initialize(
        settings: initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'chat_channel', // IMPORTANTE: Mismo ID que usamos en el Backend TypeScript
      'Notificaciones de Chat',
      description: 'Alertas de nuevos mensajes y ventas en el Mercado Local.',
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 4. Configurar el Escucha *Background* (App dormida)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 5. Configurar el Escucha *Foreground* (App Abierta en Pantalla - Banner Custom Local)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 [FCM Foreground] Got a message whilst in the foreground!');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // Si el Firebase Push llegó con Nodo de Notificación (Title y Body) -> Lanzar Banner Visual
      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
              priority: Priority.high,
              importance: Importance.max,
            ),
          ),
        );
      }
    });
  }

  // Permite obtener el token desde la Capa de Auth para guardarlo en User(Firestore)
  static Future<String?> getDeviceToken() async {
    return await _fcm.getToken();
  }
}
