# 📚 Índice Maestro de Documentación (Wiki)

Bienvenido a la Wiki interna para desarrolladores e ingenieros de FalconByte.
_Por favor, lee la Visión General y los Estándares de Código antes de emitir tu primer Commit._

---

## 🏛️ 1. Arquitectura y Código

Todo lo referente a cómo diagramar, estructurar o alterar el esqueleto de la aplicación Flutter.

- [**1. Arquitectura Limpia (Clean Architecture)**](1_clean_architecture.md): Descubre la separación de Capas en Dominio, Datos y Presentación.
- [**3. Estado y Enrutamiento Global**](3_state_routing.md): Las bibliotecas esenciales: BLoC para UX reactiva, GetIt para dependencias en memoria y GoRouter para navegación declarativa.
- [**5. Guía de Dependencias**](5_dependencies_guide.md): Breviario de para qué sirve cada paquete del entorno _pub.dev_ instalado en el `pubspec.yaml`.
- [**6. Estándares de Código (Buenas Prácticas)**](6_coding_standards.md): Tipado nulo estricto, Convenciones de Nomenclatura (Naming), Limpieza de UI y Reglas Anti-Excepciones.

---

## ☁️ 2. Infraestructura Backend (Cloud)

FalconByte es un proyecto _Serverless_. Administramos nuestros propios flujos HTTP en la nube.

- [**2. Arquitectura de Base de Datos y Firebase**](2_firebase_backend.md): Conoce por qué usamos Firestore para listar los chats y Realtime Database para la latencia en milisegundos.
- [**8. Guía de Acceso Institucional (Microsoft Azure)**](8_microsoft_auth_guide.md): Tutorial para administradores sobre cómo generar llaves SSH OAuth2 en un Entra ID para evitar acceso no escolar.
- [**9. Manual de Integración FlutterFire**](9_firebase_setup_guide.md): Configuración de entorno local del CLI para inyectar credenciales Backend a la PC.

---

## 👥 3. Operaciones de Equipo / DevOps

Guías pensadas para la fluidez en el día a día, revisión de compañeros y configuración de estaciones nuevas.

- [**10. Estrategia y Visión General**](10_project_overview.md): El por qué de la plataforma, y el glosario de cómo está ordenado el árbol interno de carpetas `/lib`.
- [**7. Preparación de Entorno (Setup)**](7_environment_setup.md): Ayuda rápida para que los nuevos descarguen Emuladores, SDKs y compiladores a la correcta versión iOS/Android.
- [**4. Manual de Operaciones de Git**](4_git_guide.md): Obligatorio. Convenciones Semánticas de Combios `(feat, fix, docs)`, uso de ramas `develop` y Protocolo Limpio de Pull Requests (PR).
