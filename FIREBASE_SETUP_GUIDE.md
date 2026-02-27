# 🔥 Guía de Configuración de Firebase desde Cero

Esta guía te lleva paso a paso para conectar este proyecto Flutter a un nuevo proyecto de Firebase.

---

## Paso 0 — Requisitos Previos (Node.js y Firebase CLI)

Para que `flutterfire` funcione, necesitas tener instalado **Node.js** porque la herramienta de comandos de Firebase (Firebase CLI) depende de él.

1. **Descarga Node.js:** Ve a [nodejs.org](https://nodejs.org/) y descarga la versión **LTS** (Recomendada para la mayoría). Instálalo siguiendo el asistente.
2. **Instala Firebase CLI:** Una vez que tengas Node.js, abre una terminal (PowerShell) y ejecuta:

   ```bash
   npm install -g firebase-tools
   ```

   > [!IMPORTANT]
   > **Si recibes un error de "ejecución de scripts deshabilitada":**
   > Abre PowerShell como administrador y ejecuta este comando:
   > `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
   > Luego escribe `S` (Sí) y presiona Enter. Esto permitirá ejecutar los scripts de `npm`.

3. **Inicia sesión en Firebase:**
   ```bash
   firebase login
   ```
   > [!TIP]
   > **Si los comandos `node`, `npm` o `firebase` no se reconocen:**
   > Ejecuta esto en tu terminal para arreglar el PATH de esta sesión:
   >
   > ```powershell
   > $env:PATH += ";C:\Program Files\nodejs;C:\Users\gerar\AppData\Roaming\npm;$env:LOCALAPPDATA\Pub\Cache\bin"
   > ```
   >
   > Luego intenta de nuevo los pasos anteriores.

---

## Paso 1 — Crear el proyecto en Firebase Console

1. Abre [Firebase Console](https://console.firebase.google.com) e inicia sesión con tu cuenta de Google.
2. Haz clic en **"Agregar proyecto"**.
3. Escribe el nombre de tu proyecto (ejemplo: `falcon-byte`).
4. Elige si quieres habilitar Google Analytics (puedes dejarlo activado).
5. Haz clic en **"Crear proyecto"** y espera unos segundos.

---

## Paso 2 — Registrar la app Android

1. En el panel de tu proyecto Firebase, haz clic en el ícono de Android (**`</>`**).
2. En **"Nombre del paquete Android"**, escribe:
   ```
   com.example.falcon_byte
   ```
3. El alias y el SHA-1 son opcionales por ahora. Haz clic en **"Registrar app"**.
4. Descarga el archivo **`google-services.json`**.
5. **Copia ese archivo** y pégalo en:
   ```
   android/app/google-services.json
   ```
   (Reemplaza el template que ya está ahí.)
6. Haz clic en **"Siguiente"** hasta terminar el asistente (las dependencias de Gradle ya están configuradas).

---

## Paso 3 — Instalar FlutterFire CLI

Abre una terminal y ejecuta:

```bash
dart pub global activate flutterfire_cli
```

Si el comando `flutterfire` no se reconoce, agrega el directorio de pub al PATH:

```bash
# Windows (PowerShell)
$env:PATH += ";$env:APPDATA\Pub\Cache\bin"
```

---

## Paso 4 — Ejecutar `flutterfire configure`

Desde la **raíz de este proyecto**, ejecuta:

```bash
flutterfire configure
```

El asistente te preguntará:

- **¿Qué proyecto de Firebase usar?** → Selecciona el que acabas de crear.
- **¿Qué plataformas quieres configurar?** → Selecciona `android` (y opcionalmente `ios`).

Al terminar, el archivo `lib/firebase_options.dart` se rellenará automáticamente con tus credenciales reales.

---

## Paso 5 — Habilitar la base de datos en Firebase

### Opción A: Cloud Firestore (recomendada)

1. En Firebase Console, ve a **Firestore Database** → **Crear base de datos**.
2. Elige el modo de inicio (**Producción** o **Prueba**).
3. Selecciona la región más cercana (ejemplo: `us-central`).
4. Haz clic en **"Habilitar"**.

### Opción B: Realtime Database

1. En Firebase Console, ve a **Realtime Database** → **Crear base de datos**.
2. Elige la ubicación y el modo.
3. Haz clic en **"Habilitar"**.

> El proyecto ya tiene ambos paquetes en `pubspec.yaml`:
>
> - `cloud_firestore` para Firestore
> - `firebase_database` para Realtime Database

---

## Paso 6 — Ejecutar la app

```bash
flutter pub get
flutter run
```

Si todo está correcto, la app arrancará sin errores de Firebase. ✅

---

## Estructura de archivos Firebase en este proyecto

```
falcon_byte/
├── android/
│   └── app/
│       ├── google-services.json     ← Tu archivo descargado de Firebase
│       └── build.gradle.kts         ← Ya tiene el plugin google-services
├── lib/
│   ├── firebase_options.dart        ← Generado por flutterfire configure
│   └── main.dart                    ← Llama a Firebase.initializeApp()
└── pubspec.yaml                     ← Dependencias de Firebase ya incluidas
```

---

## Paquetes Firebase incluidos en `pubspec.yaml`

| Paquete             | Uso                                   |
| ------------------- | ------------------------------------- |
| `firebase_core`     | Inicialización base de Firebase       |
| `firebase_auth`     | Autenticación (email, Google, etc.)   |
| `cloud_firestore`   | Base de datos en la nube (documentos) |
| `firebase_storage`  | Almacenamiento de archivos            |
| `firebase_database` | Realtime Database                     |
| `google_sign_in`    | Login con Google                      |

---

## Problemas comunes

| Error                                   | Solución                                                                          |
| --------------------------------------- | --------------------------------------------------------------------------------- |
| `google-services.json` no encontrado    | Asegúrate de que está en `android/app/`                                           |
| `DefaultFirebaseOptions` no configurado | Ejecuta `flutterfire configure` de nuevo                                          |
| `PlatformException` al iniciar          | Verifica que el `package_name` en Firebase coincida con `com.example.falcon_byte` |
| `CERTIFICATE_VERIFY_FAILED` en iOS      | Registra el Bundle ID en Firebase Console                                         |
