import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

export class NotificacionesService {
  /**
   * Envía una notificación Push directamente a un dispositivo usando Cloud Messaging (FCM).
   * @param receptorId El UID del destinatario.
   * @param titulo Título de la alerta.
   * @param cuerpo Contenido del mensaje.
   * @param data Payload invisible adicional (ej. ruteo de pantalla).
   */
  static async enviarPushUnitario(
    receptorId: string,
    titulo: string,
    cuerpo: string,
    data?: Record<string, string>,
  ) {
    const db = admin.firestore();

    try {
      // 1. Buscar los Tokens FCM del usuario receptor en Firestore
      const userDoc = await db.collection("usuarios").doc(receptorId).get();

      if (!userDoc.exists) {
        logger.warn(`Intento de Push a un usuario inexistente: ${receptorId}`);
        return;
      }

      const userData = userDoc.data();
      const fcmTokens: string[] = userData?.fcmTokens || [];

      if (fcmTokens.length === 0) {
        logger.info(
          `El usuario ${receptorId} no tiene tokens FCM registrados. Push abortado.`,
        );
        return;
      }

      // 2. Construir el payload de la Notificación
      const mensajePayload: admin.messaging.MulticastMessage = {
        tokens: fcmTokens,
        notification: {
          title: titulo,
          body: cuerpo,
        },
        data: {
          click_action: "FLUTTER_NOTIFICATION_CLICK",
          ...data,
        },
        android: {
          priority: "high",
          notification: {
            channelId: "chat_channel", // Importante para Android 8+
            sound: "default",
          },
        },
        apns: {
          payload: {
            aps: {
              sound: "default",
            },
          },
        },
      };

      // 3. Disparar los mensajes masivos a todos los dispositivos de la persona
      const response = await admin
        .messaging()
        .sendEachForMulticast(mensajePayload);

      logger.info(
        `Notificaciones enviadas: ${response.successCount}, Fallos: ${response.failureCount}`,
      );

      // 4. (Opcional) Limpiar Tokens Inválidos (Desinstalaciones de app)
      if (response.failureCount > 0) {
        const tokensParaEliminar: string[] = [];
        response.responses.forEach((resp, idx) => {
          if (
            !resp.success &&
            resp.error?.code === "messaging/registration-token-not-registered"
          ) {
            tokensParaEliminar.push(fcmTokens[idx]);
          }
        });

        if (tokensParaEliminar.length > 0) {
          await userDoc.ref.update({
            fcmTokens: admin.firestore.FieldValue.arrayRemove(
              ...tokensParaEliminar,
            ),
          });
          logger.info(
            `Purgados ${tokensParaEliminar.length} tokens muertos del usuario ${receptorId}`,
          );
        }
      }
    } catch (error) {
      logger.error(`Error crítico enviando Push a ${receptorId}`, error);
    }
  }
}
