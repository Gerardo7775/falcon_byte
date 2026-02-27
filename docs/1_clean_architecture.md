# Arquitectura Limpia (Clean Architecture) en FalconByte

FalconByte implementa Arquitectura Limpia (basada en los principios de Robert C. Martin). El objetivo principal es la **separación de responsabilidades**, dividiendo el software en capas concéntricas aisladas.

## Filosofía Principal

1. **Independencia de Frameworks:** La arquitectura no debe depender de bibliotecas de software pesadas o cambios en Flutter.
2. **Testabilidad:** Las reglas de negocio (Dominio) pueden probarse sin la interfaz de usuario, base de datos o conexión web.
3. **Independencia de la UI:** La interfaz (Pantallas/Widgets) puede cambiar fácilmente sin alterar las reglas del sistema.
4. **Independencia de la Base de Datos:** Puedes cambiar Firebase por PostgreSQL, MongoDB, etc., y el núcleo de la aplicación no se enteraría.

## Estructura de Capas en FalconByte

El proyecto está organizado "por Feature" (funcionalidad) dentro de la carpeta `lib/features/`.
Cada funcionalidad (Ej: `auth` o `chat`) se divide internamente en 3 capas fundamentales:

### 1. Domain (Capa de Dominio) - El Núcleo

Es el corazón de la aplicación. **NO puede importar ninguna otra capa (Ni Data, Ni Presentation).**
Contiene las reglas de negocio puras escritas en Dart.

- **Entities:** Clases simples que representan objetos del negocio puro (Ej. `Usuario`, `Mensaje`). No saben nada sobre JSON o Firebase.
- **Repositories (Interfaces):** Contratos abstractos (`abstract class`) que definen qué operaciones de datos necesita el dominio (Ej. `ChatRepository`). NO dicen _CÓMO_ se consiguen esos datos.
- **Use Cases:** Lógica de negocio específica (Ej. `EnviarMensajeUseCase`). Orquestan el flujo de datos apoyándose en el contrato del Repositorio.

### 2. Data (Capa de Datos) - Conexión al mundo exterior

Esta capa es responsable de saber cómo recuperar o enviar la información (Internet, Caché, Bases de Datos).
Su labor principal es implementar los contratos (Interfaces) declarados por la capa de Dominio.

- **Models:** Son idénticos a las `Entities`, pero agregan los métodos `.fromJson()` y `.toJson()`. Saben cómo serializar datos desde formatos externos como los de Firebase.
- **DataSources:** Clases que realizan las conexiones a APIs específicas (Ej. `AuthRemoteDataSource` usando FirebaseAuth o `ChatRemoteDataSource` usando Firestore).
- **Repositories (Implementaciones):** Aquí implementamos las Interfaces de la capa Dominio (Ej. `ChatRepositoryImpl`). Actúan como intermediarios: Unen el DataSource externo con el UseCase, atrapan errores HTTP y los convierten en errores estándar (`Failures`).

### 3. Presentation (Capa de Presentación) - Lo que el usuario ve

Es responsable de mostrar la interfaz visual interactiva e interceptar eventos. Depende completamente del Dominio para su lógica.

- **Screens / Pages:** Son los UI completos (Ej. `HomeScreen.dart`). Deben ser lo más limpios posibles, sin lógica pesada.
- **Widgets:** Partes reusables de UI (Ej. `MessageBubble`).
- **BLoC / Cubit:** Gestionan el **Estado** de la pantalla. Reciben Eventos de las Screens, ejecutan los Use Cases de Dominio, deciden si hay "Carga", "Éxito" o "Falla" y emiten Estados nuevos para que la interfaz se re-dibuje reactivamente.

---

## Flujo de Información (Rule of Dependency)

Visualiza el flujo de la siguiente manera:

1. El Usuario toca "Enviar" en `ChatScreen` (**Presentation**).
2. La Screen despacha el evento de enviar al `ChatBloc` (**Presentation**).
3. El Bloc invoca el `EnviarMensajeUseCase` (**Domain**).
4. El UseCase aplica reglas de formato y ordena guardar usando el contrato `ChatRepository` (**Domain**).
5. La inyección de dependencias dirige ese contrato a su implementación `ChatRepositoryImpl` (**Data**).
6. El Repositiorio convierte la **Entity** a **Model** y usa el `ChatRemoteDataSource` (**Data**) para finalmente postearlo en **Firebase**.

¡Todo fluyendo desde afuera hacia adentro, protegiendo siempre al Dominio interior!
