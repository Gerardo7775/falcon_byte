# Visión General y Estrategia del Proyecto 🦅

**FalconByte** nace de la necesidad de unificar la fragmentada experiencia universitaria. No es un simple clon de un foro, sino un **Ecosistema Académico Multipropósito** escalable que integra servicios vitales (Cafetería, Comercio y Comunicación Institucional) bajo el amparo de la identidad única del estudiante.

---

## 🎯 Estrategia y Objetivos de Negocio

El objetivo técnico es crear un sistema **robusto pero ágil** (Client-Side Serverless rendering).

1. **Fricción Cero en Onboarding:** Los alumnos ya tienen una identidad. Forzarlos a crear cuentas nuevas causaría deserción. Usamos su cuenta Microsoft Universitaria para una entrada instantánea y legitimada, previniendo usuarios _bot_ o falsos.
2. **Alta Disponibilidad:** Una cafetería o comercio no puede caer en "mantenimiento" a mitad del día. La escalabilidad de Firebase asume el balanceo de carga permitiéndonos dormir tranquilos durante "horas pico".
3. **Escalabilidad Horizontal UI/UX:** Al usar Clean Architecture, los componentes de Home (Explorar, Publicar, Favoritos) actúan como "MiniApps" que pueden desecharse o expandirse libremente.

---

## 🏗️ Estructura del Repositorio (File Tree Analítico)

Comprender la raíz de las carpetas es vital para no romper el patrón establecido de módulos `[features]`:

```text
falcon_byte/
│
├── android/                 # [Nativo] Archivos de compilación para Android OS (Gradle, Kotlin, Manifest)
├── ios/                     # [Nativo] Archivos pre-compilados de Swift y CocoaPods
├── docs/                    # [Documentación] Manuales de desarrollo, guías y flujos del equipo
│
├── lib/                     # [Motor Flutter] Directorio principal
│   ├── core/                # Reglas compartidas entre todas las Vistas
│   │   ├── di/              # Inyección de Dependencias Singleton (get_it)
│   │   ├── error/           # Excepciones mapeadas a Failures
│   │   ├── router/          # Enrutamiento centralizado usando GoRouter
│   │   ├── theme/           # Constants de colores, bordes y estilos base (AppTheme)
│   │   └── utils/           # Extensiones y constantes de Strings puras
│   │
│   ├── features/            # [Mini-Aplicaciones Aisladas]
│   │   ├── auth/            # Logeo de Microsoft, Cierre de Sesión, Extracción de Token
│   │   ├── chat/            # RTDB Mensajería, Streams Asíncronos, MessageBubbles
│   │   └── home/            # Dashboard Principal, Perfil de Usuario, Favoritos
│   │
│   ├── main.dart            # "El Interruptor". Enciende Firebase, arranca ServiceLocator y levanta Material.
│   └── firebase_options.dart# Llaves secretas autogeneradas de Google. NUNCA DEBEN SER PUBLICADAS (si no son web keys).
│
├── test/                    # Pruebas automatizadas (Unitarias, Mocks, Widget Tests)
├── pubspec.yaml             # Manifest del proyecto (Versiones de Paquetes y Nombres de Assets)
└── README.md                # Portada del Repositorio para Github
```
