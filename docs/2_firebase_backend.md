# Backend de FalconByte: Firebase Architecture

La infraestructura Backend del proyecto está 100% alojada y orquestada en los servicios Serverless de Google Cloud (Firebase).

## 1. Firebase Authentication & Microsoft Entra

El login inicial de la aplicación no maneja contraseñas de forma local. En su lugar, el acceso está restringido al **Azure Active Directory** de la institución.
Se utiliza el `OAuthProvider("microsoft.com")` configurado como **Múltiple/Inquilino Único**. Firebase Auth actúa como mediador recibiendo el Token de Microsoft y creando un perfil en su base de datos global y en Firestore para referencias futuras.

## 2. Abordaje Híbrido de Base de Datos para Chat

Implementamos una solución arquitectónica que combina dos Bases de Datos NoSQL distintas de Firebase para maximizar rentabilidad y velocidad simultáneamente.

### Cloud Firestore (Almacenamiento Estructural Documental)

Firestore es excelente para búsquedas compuestas y almacenamiento indexado. Lo utilizamos para guardar los "metadatos" de las Salas de Conversación.

- **Colección: `conversaciones`**
  - Guarda IDs de participantes en array optimizado para consultas rápidas (`array_contains`).
  - Guarda la última actualización de actividad (hora y último fragmento de texto) para armar la Lista Principal de Chats que se re-ordena dinámicamente.
  - Genera Streams de escaso volumen (se lee 1 sola vez por charla en el Home).

### Firebase Realtime Database (Sincronización de Alta Velocidad)

Firestore cobra por cada lectura de documento. Si usáramos Firestore para los mensajes unitarios de chat, la cuota gratuita se agotaría extremadamente rápido por ser una app intensiva. Por ende utilizamos Realtime DB para esto.

- **Ruta Clave/Valor: `/chats/{conversacionId}/mensajes`**
  - RTDB es una inmensa estructura de árbol JSON continuo. No cobra por cantidad de lecturas de nodos, sino por el **peso total del Ancho de Banda** descargado.
  - Es significativamente más veloz detectando inserciones gracias a su enchufe constante WebSockets bajo nivel. Perfecta para latencia < 30ms en chat.
  - Ofrece persistencia Offline de primera clase: si envías un mensaje en un modo sin datos celulares, la RTDB guarda el JSON de forma local y, apenas haya señal, empujará las colas silenciosamente a la nube.

---

En nuestro `ChatRemoteDataSourceImpl`, verás como Flutter divide inteligentemente las escrituras de Firestore para iniciar la Sala y la inyección a RTDB para alojar el contenido de los textos.
