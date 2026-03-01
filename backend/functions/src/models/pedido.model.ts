// backend/functions/src/models/pedido.model.ts
import * as admin from 'firebase-admin';

export interface Pedido {
    id?: string;
    alumnoId: string;
    items: { productId: string; cantidad: number }[];
    total: number;
    status: 'pendiente' | 'pagado' | 'entregado';
    metodoPago: 'efectivo' | 'tarjeta' | 'saldo_tec';
    codigoRecoleccion?: string;
    createdAt: admin.firestore.FieldValue | admin.firestore.Timestamp; 
}
