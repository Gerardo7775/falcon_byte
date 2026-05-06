import * as logger from 'firebase-functions/logger';

export class AppError extends Error {
  constructor(
    public readonly code: 'invalid-argument' | 'unauthenticated' | 'permission-denied' | 'not-found' | 'internal' | 'failed-precondition',
    message: string,
    public readonly details?: unknown
  ) {
    super(message);
    this.name = 'AppError';
  }
}

export const handleError = (error: unknown): never => {
  if (error instanceof AppError) {
    logger.warn(`AppError: [${error.code}] ${error.message}`, error.details);
    // En un entorno de Callable Functions, lanzar el error de Firebase adecuado
    const { HttpsError } = require('firebase-functions/v2/https');
    throw new HttpsError(error.code, error.message, error.details);
  }

  logger.error('Unhandled internal error:', error);
  const { HttpsError } = require('firebase-functions/v2/https');
  throw new HttpsError('internal', 'Ocurrió un error interno en el servidor.');
};
