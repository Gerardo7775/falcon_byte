import * as z from 'zod';

export const generarVoucherSchema = z.object({
  productoId: z.string().min(1, 'El ID del producto es requerido'),
  cantidad: z.number().int().positive('La cantidad debe ser mayor a 0'),
  metodoPago: z.enum(['saldo_tec', 'efectivo', 'tarjeta']),
});

export type GenerarVoucherRequest = z.infer<typeof generarVoucherSchema>;
