# Estándares de Código y Buenas Prácticas

Un código mantenible es aquel que puede ser comprendido por cualquier desarrollador del equipo meses después de haber sido escrito. Para el proyecto FalconByte, adherimos estrictamente a las siguientes normas:

## 1. Nomenclatura (Naming Conventions)

- **Clases, Enums, Typedefs**: `PascalCase` (Ej: `UserProfileScreen`, `AuthBloc`).
- **Variables, Métodos, Instancias**: `camelCase` (Ej: `iniciarSesion()`, `usuarioId`).
- **Archivos y Carpetas**: `snake_case` (Ej: `auth_bloc.dart`, `home_screen.dart`). _NUNCA usar mayúsculas ni espacios en los nombres de archivos_.
- **Archivos de UI vs Lógica**: Los archivos de UI siempre terminan con el sufijo de su tipo: `_screen.dart`, `_widget.dart`, `_dialog.dart`.

## 2. Limpieza de Imports

- Nunca se deben usar importaciones de ruta absoluta del sistema (Ej. `import 'file:///...'`).
- Mantén las importaciones relativas limpias. Importar hermanos (archivos en el mismo directorio) directamente mediante su nombre.
- Si vas a importar desde un `feature` distinto, usa la estructura relativa acortada: `import '../../feature_name/...'`.

## 3. Tipado Fuerte y Seguridad Nula (Null Safety)

- Utiliza **tipado explícito** al declarar variables siempre que no sea ruidoso. En casos obvios usa `final` o `const` pero evita el tipado dinámico (`dynamic`) a menos que trates con JSON inexplorados.
- Trata los errores con prudencia. Evita el operador de exclamación `!` (Bang Operator) a toda costa. Si un valor puede ser nulo, compruébalo primero o provee un valor por defecto usando `??`.
  ❌ Mal: `String nombre = usuario!.nombre;`
  ✅ Bien: `String nombre = usuario?.nombre ?? 'Desconocido';`

## 4. UI Responsiva y Limpia (Presentation Layer)

- **Nunca incluyas lógica pesada en un Widget**. Si necesitas filtrar listas, hacer llamadas HTTP o guardar en disco, hazlo en un `Bloc` o `UseCase`.
- Refactoriza el método `build()`. Si tu método `build` pasa de 100 líneas, debes extraer partes en Métodos locales privados (Ej: `_buildHeader()`) o en subclases de Widgets sin estado (StatelessWidgets).
- **Constantes Mágicas**: Evita quemar números mágicos o colores a lo largo del código. Usa el archivo genérico del tema (por ejemplo, llamadas relativas como `Theme.of(context).primaryColor` en vez de `Colors.blue` fijos en memoria).

## 5. Manejo de Excepciones vs Failures

- Las Excepciones (`Exception`) solo las arroja la Capa de Datos (`Data`).
- La Capa de Repositorios atrapa esas Excepciones, las formatea, y devuelve hacia el dominio (Domain) objetos de clase `Failure` inofensivos. La vista (`Bloc`) nunca recibe Excepciones o _StackTraces_, solo `Failures` mapeados.
