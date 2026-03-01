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
exports.GenerarVoucherService = void 0;
const admin = __importStar(require("firebase-admin"));
const errors_1 = require("../core/errors");
class GenerarVoucherService {
    /**
     * Ejecuta la lógica central y segura para crear un voucher de compra.
     */
    static async ejecutar(userId, data) {
        var _a, _b, _c;
        const db = admin.firestore();
        // 1. (Simulado) Buscar el producto en la base de datos para validar precio y stock
        const productoRef = db.collection('productos_cafeteria').doc(data.productoId);
        const productoSnap = await productoRef.get();
        // NOTA: Para este ejemplo de arquitectura, si el producto no existe crearemos datos dummy
        // En producción, aquí debe fallar si no existe
        const precioUnitario = productoSnap.exists ? (_a = productoSnap.data()) === null || _a === void 0 ? void 0 : _a.precio : 45.00;
        const nombreProducto = productoSnap.exists ? (_b = productoSnap.data()) === null || _b === void 0 ? void 0 : _b.nombre : 'Hamburguesa Clásica';
        // 2. Calcular total
        const total = precioUnitario * data.cantidad;
        // 3. Validar saldo si paga con "saldo_tec" (Lógica simulada)
        if (data.metodoPago === 'saldo_tec') {
            const userRef = db.collection('usuarios').doc(userId);
            const userSnap = await userRef.get();
            const saldoActual = ((_c = userSnap.data()) === null || _c === void 0 ? void 0 : _c.saldo_tec) || 0;
            if (saldoActual < total) {
                throw new errors_1.AppError('failed-precondition', 'Saldo insuficiente para realizar el pedido.');
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
exports.GenerarVoucherService = GenerarVoucherService;
//# sourceMappingURL=generarVoucherService.js.map