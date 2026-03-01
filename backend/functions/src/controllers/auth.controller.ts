import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import * as logger from 'firebase-functions/logger';
import { Usuario } from '../models/usuario.model';

/**
 * Trigger que se ejecuta automáticamente cuando Firebase Auth crea un nuevo usuario.
 * Su función principal es asignar Custom Claims base (Roles).
 */
export const onUserCreated = functions.auth.user().onCreate(async (user) => {
    try {
        const customClaims = {
            alumno: true,    // Por defecto, todos son alumnos
            vendedor: false, // Solo un flujo de Admin lo podría habilitar en la app
            admin: false
        };

        // Asignar el Custom Claim directamente en el Token de sesión
        await admin.auth().setCustomUserClaims(user.uid, customClaims);
        logger.info(`Claims de rol [alumno: true] asignados exitosamente a: ${user.uid}`);

        // Opcional: Escribir el documento en Firestore para que el Frontend pueda mapearlo sin decodificar token
        const db = admin.firestore();
        const infoUsuario: Usuario = {
            uid: user.uid,
            correo: user.email || '',
            nombre: user.displayName || 'Nuevo Halcón',
            saldo_tec: 0,
            roles: customClaims,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        await db.collection('usuarios').doc(user.uid).set(infoUsuario, { merge: true });

    } catch (error) {
        logger.error('Error configurando Custom Claims para nuevo usuario', error);
    }
});
