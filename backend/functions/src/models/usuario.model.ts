// backend/functions/src/models/usuario.model.ts
import * as admin from 'firebase-admin';

export interface Usuario {
    uid: string;
    nombre: string;
    correo: string;
    saldo_tec: number;
    fotoUrl?: string;
    roles: {
        admin: boolean;
        vendedor: boolean;
        alumno: boolean;
    };
    createdAt: admin.firestore.FieldValue | admin.firestore.Timestamp;
}
