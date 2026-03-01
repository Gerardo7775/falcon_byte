import * as admin from 'firebase-admin';
import { GenerarVoucherRequest } from '../core/schemas';
import { AppError } from '../core/errors';

export class GenerarVoucherService {
  /**
   * Ejecuta la lógica central y segura para crear un voucher de compra.
   */
  static async ejecutar(userId: string, data: GenerarVoucherRequest) {
    const db = admin.firestore();

    // 1. (Simulado) Buscar el producto en la base de datos para validar precio y stock
    const productoRef = db.collection('productos_cafeteria').doc(data.productoId);
    const productoSnap = await productoRef.get();

    // NOTA: Para este ejemplo de arquitectura, si el producto no existe crearemos datos dummy
    // En producción, aquí debe fallar si no existe
    const precioUnitario = productoSnap.exists ? productoSnap.data()?.precio : 45.00;
    const nombreProducto = productoSnap.exists ? productoSnap.data()?.nombre : 'Hamburguesa Clásica';

    // 2. Calcular total
    const total = precioUnitario * data.cantidad;

    // 3. Validar saldo si paga con "saldo_tec" (Lógica simulada)
    if (data.metodoPago === 'saldo_tec') {
      const userRef = db.collection('usuarios').doc(userId);
      const userSnap = await userRef.get();
      const saldoActual = userSnap.data()?.saldo_tec || 0;

      if (saldoActual < total) {
        throw new AppError('failed-precondition', 'Saldo insuficiente para realizar el pedido.');
      }

      // Descontar saldo (Transaccional)
      await userRef.update({
        saldo_tec: admin.firestore.FieldValue.increment(-total)
      });
    }

    // 4. Generar código único de recolección (Ej. AB12C)
    const codigoRecoleccion = Math.random().toString(36).substring(2, 7).toUpperCase();

    // 5. Crear el Voucher de forma segura usando Admin SDK
    const voucherData = {
      userId,
      productoId: data.productoId,
      productoNombre: nombreProducto,
      cantidad: data.cantidad,
      total,
      metodoPago: data.metodoPago,
      codigoRecoleccion,
      estado: 'pagado_esperando_entrega', // 'pagado_esperando_entrega', 'entregado', 'cancelado'
      fechaCreacion: admin.firestore.FieldValue.serverTimestamp(),
    };

    const docRef = await db.collection('vouchers').add(voucherData);

    return {
      voucherId: docRef.id,
      codigoRecoleccion,
      total,
      mensaje: 'El pedido fue procesado exitosamente.'
    };
  }
}
