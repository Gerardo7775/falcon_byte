"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.NotificacionesService = void 0;
const admin = __importStar(require("firebase-admin"));
const logger = __importStar(require("firebase-functions/logger"));
class NotificacionesService {
    /**
     * Envía una notificación Push directamente a un dispositivo usando Cloud Messaging (FCM).
     * @param receptorId El UID del destinatario.
     * @param titulo Título de la alerta.
     * @param cuerpo Contenido del mensaje.
     * @param data Payload invisible adicional (ej. ruteo de pantalla).
     */
    static async enviarPushUnitario(receptorId, titulo, cuerpo, data) {
        const db = admin.firestore();
        try {
            // 1. Buscar los Tokens FCM del usuario receptor en Firestore
            const userDoc = await db.collection("usuarios").doc(receptorId).get();
            if (!userDoc.exists) {
                logger.warn(`Intento de Push a un usuario inexistente: ${receptorId}`);
                return;
            }
            const userData = userDoc.data();
            const fcmTokens = (userData === null || userData === void 0 ? void 0 : userData.fcmTokens) || [];
            if (fcmTokens.length === 0) {
                logger.info(`El usuario ${receptorId} no tiene tokens FCM registrados. Push abortado.`);
                return;
            }
            // 2. Construir el payload de la Notificación
            const mensajePayload = {
                tokens: fcmTokens,
                notification: {
                    title: titulo,
                    body: cuerpo,
                },
                data: Object.assign({ click_action: "FLUTTER_NOTIFICATION_CLICK" }, data),
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
            logger.info(`Notificaciones enviadas: ${response.successCount}, Fallos: ${response.failureCount}`);
            // 4. (Opcional) Limpiar Tokens Inválidos (Desinstalaciones de app)
            if (response.failureCount > 0) {
                const tokensParaEliminar = [];
                response.responses.forEach((resp, idx) => {
                    var _a;
                    if (!resp.success &&
                        ((_a = resp.error) === null || _a === void 0 ? void 0 : _a.code) === "messaging/registration-token-not-registered") {
                        tokensParaEliminar.push(fcmTokens[idx]);
                    }
                });
                if (tokensParaEliminar.length > 0) {
                    await userDoc.ref.update({
                        fcmTokens: admin.firestore.FieldValue.arrayRemove(...tokensParaEliminar),
                    });
                    logger.info(`Purgados ${tokensParaEliminar.length} tokens muertos del usuario ${receptorId}`);
                }
            }
        }
        catch (error) {
            logger.error(`Error crítico enviando Push a ${receptorId}`, error);
        }
    }
}
exports.NotificacionesService = NotificacionesService;
//# sourceMappingURL=notificacionesService.js.map