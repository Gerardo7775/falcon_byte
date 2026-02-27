# Manejo de Estados y Enrutamiento

En FalconByte priorizamos flujos predecibles, inmutables y robustos gracias a dos librerías estándar en Flutter Industrial.

## Manejo de Estado (BLoC Pattern)

Utilizamos el patrón **BLoC** (Business Logic Component) mediante el paquete oficial `flutter_bloc`. Ocasionalmente se pueden usar variantes ligeras como **Cubit** si la lógica no requiere emitir ráfagas de eventos paralelos.

### ¿Por qué BLoC?

El BLoC separa permanentemente todo lo que "se ve" de las "reglas" (Event-Driven Architecture).
En lugar del caótico `setState`, BLoC toma `States` predecibles y cerrados que representan con exactitud qué hay en pantalla (Cargando, Ok, Error fatal).

### Estructura de un Bloc:

Todo BLoC tiene 3 archivos (ubicados en `features/[nombre_feature]/presentation/bloc`):

- **`*_event.dart`**: Interfaces (Clases) nombradas como acciones. _Ej: `EnviarMensajeEvent`_
- **`*_state.dart`**: Interfaces deterministas para que la UI se pinte en base a campos inmutables. _Ej: `ChatConErrorFatal(mensaje)`_
- **`*_bloc.dart`**: Escucha el torrente (`Stream`) de Eventos entrantes y usa `emit(NuevoState)` usando Casos de Uso. Los Streams activos se encadenan usando preferiblemente `emit.forEach()`.

---

## Inyección de Dependencias (Service Locator / GetIt)

A lo largo del proyecto verás que utilizamos el término **`sl<NombreDeLaClase>()`**. Esto proviene del paquete `get_it`.
Es nuestro localizador de servicios central que vive en `lib/core/di/injection.dart`.

Cuando la App inicia o se llama un UseCase en un `BlocProvider`, el `get_it` automáticamente se hace cargo de construir el Repositorio de Firebase, inyectárselo al UseCase pertinente e instantiatearlo. Esto simplifica nuestra vida borrando todas las herencias caóticas y anidadas como:
_`bloc: MiBloc(usecase: MiUseCase(repositorio: MiRepo(auth: Firebase, ws: Websockets)))`_

En FalconByte únicamente pedimos la clase `sl<MiBloc>()` y GetIt arma el árbol de dependencia subyacente. Los DataSources/Repos se declaran como Singleton, mientras los BLoCs como Factories (para crear instancias separadas frescas).

---

## Enrutador Global: GoRouter

En vez del frágil sistema Navigator 1.0 empujando pantallas `Navigator.push`, usamos el potente enrutador declarativo `go_router`.

Todas las reglas de ruteo están especificadas en `lib/core/router/app_router.dart`:

- GoRouter funciona inyectando las URLs de internet para navegación directa (`context.go('/conversaciones')`).
- Si estamos navegando internamente y solo deseamos empujar una vista que permita presionar "Atrás", usamos `context.push('/chat/sala-1')`.
- Las transferencias de datos complejos de pantalla a pantalla se hacen por diccionarios pasados por el parámetro `extra`.
- Las redirecciones por roles o estado de autenticación (Ej. forzar `/login` si no hay token de Microsoft) se orquestan centralizadamente desde el atributo dinámico `redirect` en el Router Global o desde los "Listeners" reactivos del UI.
