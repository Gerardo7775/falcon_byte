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
exports.notificarNuevoMensaje = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
const logger = __importStar(require("firebase-functions/logger"));
const notificacionesService_1 = require("../services/notificacionesService");
/**
 * Escucha las creaciones/actualizaciones en la colección central de Conversaciones.
 * Como el empaquetado del RTDB escala la complejidad muy rápido, Firestore (conversaciones)
 * contiene el 'ultimoMensaje'. Escuchamos ese cambio para enviar la notificación
 * hacia la persona que NO fue la escritora de ese último mensaje.
 */
exports.notificarNuevoMensaje = functions.firestore
    .document("conversaciones/{conversacionId}")
    .onWrite(async (change, context) => {
    var _a;
    const docPostCambio = change.after.data();
    const docPrevCambio = change.before.data();
    // Si el documento se borró, no hay nada que notificar.
    if (!docPostCambio) {
        return null;
    }
    // Recuperar información de la sala (Ej. "Chat 1vs1")
    const participantesIds = docPostCambio.participantesIds || [];
    const ultimoMensaje = docPostCambio.ultimoMensaje || "";
    // Prevenir Spam: Solo notificar si el texto verdaderamente cambió respecto al bloque anterior
    if (docPrevCambio && docPrevCambio.ultimoMensaje === ultimoMensaje) {
        logger.info(`El snippet de la conversacion ${context.params.conversacionId} no cambió (Probablemente se modificó otro estado). Omitiendo push.`);
        return null;
    }
    try {
        // Estrategia: Buscar al autor real del mensaje accediendo a Firebase RTDB para mayor precisión
        // O simplemente usar heurísticas. En proyectos donde RTDB y Firestore se hibridan,
        // este paso suele implicar deducir quién NO mandó el mensaje analizando los tiempos.
        // 💡 WORKAROUND INTELIGENTE 💡
        // En una conversación 1vs1, buscamos al remitente leyendo la propiedad auxiliar (últimoRemitente).
        // Si no existe, buscamos a AMBOS y les mandamos notificación silenciosa, o pedimos que Firestore tenga `remitenteId` del último mensaje.
        // Para fines de esta arquitectura impecable, asumiremos que `remitenteUltimoMensaje` forma parte del payload en Firestore.
        const emisorId = docPostCambio.remitenteUltimoMensaje;
        if (!emisorId) {
            logger.warn("Conversación no contiene <remitenteUltimoMensaje>. No sé a quién descartar del push de Notificación.");
            return null;
        }
        // Filtrar del Array de participantes para encontrar AL RECEPTOR
        const receptoresIds = participantesIds.filter((id) => id !== emisorId);
        if (receptoresIds.length === 0) {
            return null;
        }
        // Consultar el nombre del EMISOR para poner en el Título ("Diego T. te ha mandado un mensaje")
        const emisorDoc = await admin
            .firestore()
            .collection("usuarios")
            .doc(emisorId)
            .get();
        const nombreEmisor = emisorDoc.exists
            ? (_a = emisorDoc.data()) === null || _a === void 0 ? void 0 : _a.nombre
            : "Nuevo Mensaje";
        // Armar carga e invocar al Servicio Maestro de Notificaciones
        const tituloPush = `Mensaje de ${nombreEmisor}`;
        const cuerpoPush = ultimoMensaje.length > 50
            ? ultimoMensaje.substring(0, 47) + "..."
            : ultimoMensaje;
        const routingData = { chatId: context.params.conversacionId };
        // Emitir en paralelo a todos los receptores (Por si es un grupo)
        const pushPromises = receptoresIds.map((receptorId) => notificacionesService_1.NotificacionesService.enviarPushUnitario(receptorId, tituloPush, cuerpoPush, routingData));
        await Promise.all(pushPromises);
        logger.info(`Notificaciones de Chat procesadas exitosamente para sala: ${context.params.conversacionId}`);
        return null;
    }
    catch (error) {
        logger.error("Error masivo al intentar notificar nuevo mensaje en la sala.", error);
        return null;
    }
});
//# sourceMappingURL=chat.controller.js.map