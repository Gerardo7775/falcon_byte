import * as admin from 'firebase-admin';

// Inicializar de forma global la SDK de Admin
admin.initializeApp();

// Exportar módulos (Aquí se registrarán todas las Cloud Functions)
export * from './triggers/cafeteria';
