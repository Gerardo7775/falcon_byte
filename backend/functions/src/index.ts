import * as admin from 'firebase-admin';

// Inicializar de forma global la SDK de Admin Node
admin.initializeApp();

// Exportar controladores (endpoints y triggers)
export * from './controllers/cafeteria.controller';
export * from './controllers/auth.controller';
