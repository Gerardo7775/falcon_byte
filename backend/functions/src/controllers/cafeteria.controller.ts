import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { generarVoucherSchema } from '../core/schemas';
import { handleError } from '../core/errors';
import { GenerarVoucherService } from '../services/generarVoucherService';

/**
 * Función Callable (HTTPS) para el App de Flutter.
 * Expone un endpoint seguro donde el Firebase SDK del celular se conecta de forma directa.
 */
export const crearPedido = onCall(async (request) => {
  try {
    // 1. Validar autenticación de Firebase (El usuario DEBE estar logueado)
    if (!request.auth || !request.auth.uid) {
      throw new HttpsError('unauthenticated', 'El usuario debe iniciar sesión para generar un voucher.');
    }

    // 2. Validar payload de entrada usando el Schema de Zod
    const parsedData = generarVoucherSchema.safeParse(request.data);
    if (!parsedData.success) {
      // Si mandan basura desde el front, interceptar aquí y retornar 400
      throw new HttpsError('invalid-argument', 'Los datos del pedido son inválidos.', parsedData.error.format());
    }

    // 3. Pasar control al Service Repository
    const resultado = await GenerarVoucherService.ejecutar(request.auth.uid, parsedData.data);
    
    // 4. Retornar DTO de éxito a Flutter
    return resultado;

  } catch (error) {
    // Orquestador global de errores delega o lanza Exception de Https Error
    return handleError(error);
  }
});
