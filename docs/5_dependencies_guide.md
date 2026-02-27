# Guía de Dependencias Principales

El proyecto FalconByte utiliza diversas dependencias seleccionadas cuidadosamente para asegurar el rendimiento, mantenibilidad y escalabilidad del código. Todas se encuentran registradas en el archivo `pubspec.yaml`.

## 🏗️ Arquitectura y Estado

- **`flutter_bloc` & `bloc`**: Librería principal para el manejo de estado usando el patrón BLoC (Business Logic Component). Separa estrictamente la presentación de la lógica de negocio.
- **`get_it`**: Inyector de dependencias (Service Locator). Nos permite acceder a repositorios, casos de uso y BLoCs globalmente sin tener que pasarlos por constructores infinitos (el patrón Singleton y Factory lazy-loaded).
- **`dartz`**: Permite la programación funcional en Dart. Se usa principalmente para la clase `Either<L, R>`, retornando siempre excepciones (`Failures`) en el Lado Izquierdo (Left) o el resultado esperado en el Derecho (Right), forzando al UI a manejar los errores sin _crashes_.
- **`equatable`**: Utilidad para comparar objetos en Dart basándose en sus valores en lugar de en su espacio en memoria. Fundamental para que BLoC sepa cuándo re-dibujar la pantalla sin usar memoria extra.

## 🧭 Enrutamiento

- **`go_router`**: El estándar de Google para Navigator 2.0. Proporciona ruteo declarativo, basado en URLs, "Deep Linking", y manejo de redirecciones de autenticación global (Redirección protegida cuando expira un token).

## 🔥 Firebase y Autenticación

- **`firebase_core`**: Inicializa el puente de comunicación entre Flutter y el proyecto en la Nube de Google.
- **`firebase_auth`**: Maneja los Tokens JWT, sesiones y proveedores OIDC (Login de Microsoft, Google, etc.).
- **`cloud_firestore`**: Base de datos NoSQL documental de Firebase. Ideal para configuraciones globales, directorios indexados y metadatos de las Salas de Chat (queries complejos).
- **`firebase_database`**: Realtime Database de Firebase (base de datos en árbol JSON puro). Excelente para sincronización de alto volumen y baja latencia. Usada exclusivamente para la mensajería individual de chat.

## 🎨 Utilidades Visuales y UX

- **`google_fonts`**: Importa dinámicamente tipografías personalizadas (como Poppins o Roboto) sin incluirlas forzosamente en los _assets_ estáticos, aligerando el peso final del APK/IPA.
- **Icons y Themes**: Dependencias nativas de Material Design 3 (`material.dart`).

_(Para ver la lista exacta y las versiones estancadas, consulta el archivo `pubspec.yaml`)_.
