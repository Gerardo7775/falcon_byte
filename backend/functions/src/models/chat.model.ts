import * as admin from "firebase-admin";

export interface Mensaje {
  id: string; // ID único del mensaje
  remitenteId: string; // UID del usuario que envió el mensaje
  contenido: string; // El texto del mensaje
  timestamp: admin.firestore.FieldValue | admin.firestore.Timestamp | number; // Guardado en timestamp
  leido: boolean; // Estado de lectura
}

export interface Conversacion {
  id: string; // ID de la sala (Ej. usuario1_usuario2)
  participantesIds: string[]; // Arreglo con los IDs de los 2 usuarios
  ultimoMensaje: string; // Snippet del último mensaje
  fechaUltimoMensaje: admin.firestore.FieldValue | admin.firestore.Timestamp; // Para ordenar la lista de chats
}
