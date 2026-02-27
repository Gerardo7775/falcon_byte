# 🔥 Guía Integral de Configuración de Firebase (Refinada)

Firebase es la columna vertebral de FalconByte, proporcionando Autenticación, Base de Datos Reactiva (RTDB) y Capacidad de Búsquedas (Firestore). Aquí se describe cómo enlazar el entorno de desarrollo de un nuevo desarrollador del ecosistema u orquestar un proyecto en la nube desde cero mediante **FlutterFire CLI**.

---

## 💻 1. Requisitos Indispensables

El asistente automatizado de Firebase requiere el runtime de Node.js.

1. **Node.js**: Si no lo tienes, descárgalo e instálalo desde [nodejs.org](https://nodejs.org/).
2. **Terminal Integrada**: Usaremos la de VS Code o PowerShell.

Habilitar Scripts Remotos (SOLO WINDOWS):
Abre PowerShell como Administrador e inyecta permisos base:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 🌐 2. Inicializando Firebase CLI

Usaremos `npm` (agente de Node) para bajar las herramientas binarias de Google.

```bash
npm install -g firebase-tools
```

A continuación, enlaza tu PC a tu cuenta de Gmail institucional/personal que alberga el proyecto en Google Cloud:

```bash
firebase login
```

_Se abrirá una ventana de Chrome. Acepta los permisos de "Permitir a Firebase..."_.

## 📱 3. Descargando Configuraciones Esenciales (FlutterFire CLI)

1. **Activa globalmente el generador Dart**:

```bash
dart pub global activate flutterfire_cli
```

2. **Inyecta la Base de Datos a Android/iOS**:
   Ve a la raíz del proyecto local de FalconByte. Observa que ya tienes el `pubspec.yaml` con dependencias preexistentes. Simplemente ejecuta:

```bash
flutterfire configure
```

El asistente buscará tus proyectos en línea.

- Selecciona el proyecto deseado _(Ej. `falcon-byte-dev`)_.
- Si te pregunta las plataformas, marca al menos `android` y `ios`.

_Magia: Este comando reemplazará automáticamente los pesados archivos `google-services.json` y los diccionarios internos rescribiendo en milisegundos nuestro archivo central `lib/firebase_options.dart` para que todo encaje perfecto en el código Dart._

## 🗄️ 4. Estructura de Paquetes Instalada

Tu app corre sobre estos pilares (que ya se encuentran inyectados por pub.dev):

| Paquete oficial     | Responsabilidad Institucional                                   |
| ------------------- | --------------------------------------------------------------- |
| `firebase_core`     | "Enciende" los motores de Google Services en `.initializeApp()` |
| `firebase_auth`     | Verifica las fichas JWT y administra sesiones SSO de Azure.     |
| `cloud_firestore`   | (Metadatos) Salas y participantes de chats, índices.            |
| `firebase_database` | (RTDB) El corazón a tiempo real. Textos, leídos, escribiendo... |

## ⚠️ 5. Troubleshooting (Solución Rápida)

1. **"Dart pub no reconoce `flutterfire`"**: Significa que tu sistema operativo no tiene la ruta de Dart.
   - Entra a _Variables de Entorno_
   - Añade al PATH local: `%APPDATA%\Pub\Cache\bin`
2. **"Failed to initialize Firebase"**: Ocurre si clonas el repo por primera vez y tus dependencias C++ de Android no están alineadas. Lanza un `flutter run` para forzar que Gradle las descargue.
