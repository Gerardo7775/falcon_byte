"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.crearPedido = void 0;
const https_1 = require("firebase-functions/v2/https");
const schemas_1 = require("../core/schemas");
const errors_1 = require("../core/errors");
const generarVoucherService_1 = require("../services/generarVoucherService");
/**
 * Función Callable (HTTPS) para el App de Flutter.
 * Expone un endpoint seguro donde el Firebase SDK del celular se conecta de forma directa.
 */
exports.crearPedido = (0, https_1.onCall)(async (request) => {
    try {
        // 1. Validar autenticación de Firebase (El usuario DEBE estar logueado)
        if (!request.auth || !request.auth.uid) {
            throw new https_1.HttpsError('unauthenticated', 'El usuario debe iniciar sesión para generar un voucher.');
        }
        // 2. Validar payload de entrada usando el Schema de Zod
        const parsedData = schemas_1.generarVoucherSchema.safeParse(request.data);
        if (!parsedData.success) {
            // Si mandan basura desde el front, interceptar aquí y retornar 400
            throw new https_1.HttpsError('invalid-argument', 'Los datos del pedido son inválidos.', parsedData.error.format());
        }
        // 3. Pasar control al Service Repository
        const resultado = await generarVoucherService_1.GenerarVoucherService.ejecutar(request.auth.uid, parsedData.data);
        // 4. Retornar DTO de éxito a Flutter
        return resultado;
    }
    catch (error) {
        // Orquestador global de errores delega o lanza Exception de Https Error
        return (0, errors_1.handleError)(error);
    }
});
//# sourceMappingURL=cafeteria.controller.js.map