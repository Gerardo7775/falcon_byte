# 🦅 FalconByte 💙

**FalconByte** es una plataforma institucional interactiva, elegante e intuitiva diseñada nativamente en Flutter para brindar una experiencia inmersiva y comunitaria a todos los estudiantes e internautas relacionados con nuestro ecosistema tecnológico académico.

---

## 🚀 Módulos Principales (Escalables)

FalconByte es Modular, preparado para un crecimiento horizontal:

- **Autenticación Empresarial (Entra ID)**: Validación de dominios institucionales blindado por OAuth 2.0 y single-tenants de Azure AD (Microsoft Login).
- **Home Hub Inteligente**: Directorio en vivo de apartados sociales; Cafetería Tec, Mercado Local, Quioscos interactivos.
- **Red de Chat RTDB**: Motor subyacente de tiempo real (_low-latency_) habilitado para charlar 1v1 con cualquier alumno en directo utilizando Infraestuctura Híbrida de Bases de Datos Serverless (Cloud Firestore & RTDB).
- **Perfil de Usuario Digital**.
- Interfaz gráfica Premium, responsiva, fluida y con compatibilidad perfecta para "Dark Mode" (Modo Oscuro) en iOS y Android.

---

## 💎 Arquitectura Sostenible

Contruido desde cero pensando en la longevidad del código.

1. **Clean Architecture by Uncle Bob**: 3 Capas Aisladas (Domain, Presentation y Data) controladas con contratos Abstractos (Interfaces).
2. **Controlador de Estado BLoC**: Reactividad total guiada por Eventos mediante `flutter_bloc`. Separación completa entre Vistas (`Screens`) e Inteligencia o Lógica Subyacente (`UseCases`).
3. **Inyección de Dependencia Lazy**: Consumo eficiente de Memoria localizando Servicios Globalmente (`get_it`).

📚 _[¿Eres un desarrollador o nuevo en el equipo? Por favor revisa la carpeta `/docs` para profundizar en manuales sobre Arquitectura, Firebase, Reparto de Estado o Regalas de Git]._

---

## 🛠️ Entorno de Desarrollo (Instalación Rápida)

Asegúrate de tener un emulador encendido (preferentemente iOS o una terminal cruzada de Android).

```bash
# 1. Clona el repositorio
git clone <URL_REPOSITORIO>

# 2. Posiciónate en la raíz del proyecto
cd falcon_byte

# 3. Descarga todas mis dependencias Pub
flutter pub get

# 4. Despierta el motor
flutter run
```

### Pre-Requisitos

- SDK de Flutter >=3.19.0
- Dart SDK >=3.3.0
- Acceso de Desarrollador al Proyecto Firebase de "FalconByte" para actualizar `google-services.json` (Android) y `GoogleService-Info.plist` (iOS).

> **Aviso de Firebase:** Si compilas la aplicación por tu cuenta sin conectar el CLI de tu respectivo proyecto en la Nube con los hashes de validación OAuth cruzados, algunas funciones Premium (Login por Microsoft y Chats) no funcionarán.
