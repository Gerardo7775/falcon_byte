# Buenas Prácticas y Flujo de Trabajo en Git

Para asegurar que FalconByte mantiene un historial limpio, libre de conflictos y ordenado, el equipo debe apegarse estrictamente a este flujo estructurado de control de versiones.

## Convención de Ramas (Git Flow)

Nuestro repositorio está segmentado por ramas con propósitos específicos.

### Ramas Permanentes

1. **`main` (o `master`)**: Representa la versión estable en Producción. **PROHIBIDO empujar (push) código directamente aquí**. Toda modificación debe llegar a través de un _Pull Request_ aprobado.
2. **`develop`**: Es la rama principal de integración temporal. El código aquí está "listo" para el próximo lanzamiento, pero aún en periodo de validación y pruebas.

### Ramas Temporales (De Trabajo)

Ningún desarrollador debe codificar sobre las ramas permanentes. Cada nueva labor exige desprenderse de `develop` mediante una nueva rama temporal:

- **`feature/<nombre>`**: Para añadir una nueva característica (Ej. `feature/modulo-chat`).
- **`bugfix/<nombre>`**: Para solucionar un problema en la rama develop (Ej. `bugfix/crash-doble-login`).
- **`hotfix/<nombre>`**: Soluciones críticas urgentes que deben repararse directa e inmediatamente sobre `main` en Producción.

> **Regla de Oro:** Corta tu rama siempre desde el estado más actual de la base.
> `git checkout develop`
> `git pull origin develop`
> `git checkout -b feature/mi-nueva-caracteristica`

---

## Escribiendo un Buen Commit

Los commits son el "Diario de a bordo" del proyecto. Deben ser semánticos, claros y al grano.

**Estructura esperada:** `<tipo>(<alcance>): <descripción corta>`

- `feat`: Se añade una nueva funcionalidad.
- `fix`: Se corrige un error reportado.
- `docs`: Solo cambios en la documentación (como los README o manuales).
- `style`: Formateo de código sin alterar lógica (Ej. `dart format`).
- `refactor`: Cambio de código que no corrige un error ni añade funcionalidad (optimización).
- `test`: Añadiendo o reparando pruebas unitarias.

**Ejemplo Excelente:** `feat(chat): Implementa el sistema de burbujas en UI con RTDB`
**Ejemplo Pésimo:** `codigo nuevo` o `repare cosas` 😭

---

## Pull Requests y Merges

Cuando tu `feature` o `bugfix` está completamente terminado y probado localmente, empujas la rama a GitHub/GitLab.

1. Abre un **Pull Request (PR)**: Quieres fusionar tu rama `feature/mi-funcionalidad` **hacia** `develop`.
2. **Revisión de Código (Code Review):** Asigna a otro desarrollador u Ojo Experto para examinar tu código. Se buscarán _bugs_ visuales, violaciones de Arquitectura Limpia y _leaks_ de memoria.
3. No intentes fusionar (_Merge_) con errores en la consola del Analizador de Dart.
4. Una vez aprobado, el PR se une (Merge) hacia `develop`.
5. Tu rama remota ahora se borra para evitar estorbar. ¡Felicidades, colaboraste con éxito!
