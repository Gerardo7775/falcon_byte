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
exports.onUserCreated = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
const logger = __importStar(require("firebase-functions/logger"));
/**
 * Trigger que se ejecuta automáticamente cuando Firebase Auth crea un nuevo usuario.
 * Su función principal es asignar Custom Claims base (Roles).
 */
exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
    try {
        const customClaims = {
            alumno: true, // Por defecto, todos son alumnos
            vendedor: false, // Solo un flujo de Admin lo podría habilitar en la app
            admin: false
        };
        // Asignar el Custom Claim directamente en el Token de sesión
        await admin.auth().setCustomUserClaims(user.uid, customClaims);
        logger.info(`Claims de rol [alumno: true] asignados exitosamente a: ${user.uid}`);
        // Opcional: Escribir el documento en Firestore para que el Frontend pueda mapearlo sin decodificar token
        const db = admin.firestore();
        const infoUsuario = {
            uid: user.uid,
            correo: user.email || '',
            nombre: user.displayName || 'Nuevo Halcón',
            saldo_tec: 0,
            roles: customClaims,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        };
        await db.collection('usuarios').doc(user.uid).set(infoUsuario, { merge: true });
    }
    catch (error) {
        logger.error('Error configurando Custom Claims para nuevo usuario', error);
    }
});
//# sourceMappingURL=auth.controller.js.map