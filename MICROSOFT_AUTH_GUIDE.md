# 🪟 Guía: Autenticación con Microsoft en Firebase

Para habilitar Microsoft Auth, necesitas registrar una aplicación en **Microsoft Azure** (el panel de administración de Microsoft). Aquí tienes los pasos exactos:

---

## 1. Crear App en Microsoft Azure

1. Ve al [Portal de Azure (App Registrations)](https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade).
2. Haz clic en **"Nueva identificación"** (New registration).
3. Escribe un nombre (ej: `FalconByte-Auth`).
4. En **Tipos de cuenta compatibles**, elige según tu preferencia:
   - **OPCIÓN A (Solo Institucional):** Selecciona **"Solo inquilino único: Instituto Tecnológico de Toluca"**. Esto bloquea el acceso a cualquier correo que no sea de la institución.
   - **OPCIÓN B (Global):** Selecciona "Cualquier inquilino de Entra ID + cuentas personales" (si quieres que cualquiera con Outlook/Hotmail entre).
5. **Importante (Si elegiste Opción A):** Ve a la sección **"Información general"** y copia también el **ID de directorio (inquilino)**. Lo necesitarás en Firebase.
6. **NO** rellenes el URI de redirección todavía. Haz clic en **Registrar**.

---

## 2. Configurar el URI de Redirección

1. En el menú de la izquierda (dentro de tu app en Azure), ve a **"Autenticación"**.
2. Haz clic en **"Agregar una plataforma"** → selecciona **"Web"**.
3. En **URI de redirección**, pega la URL que te dio Firebase (la que sale en tu captura):
   ```
   https://falcon-byte.firebaseapp.com/__/auth/handler
   ```
4. Haz clic en **Configurar**.

---

## 3. Obtener el ID de Aplicación

1. Ve a la sección **"Información general"** (Overview).
2. Copia el **ID de aplicación (cliente)**.
   - _Este es el valor que debes pegar en el primer campo de Firebase._

---

## 4. Obtener el Secreto de Aplicación

1. Ve a la sección **"Certificados y secretos"**.
2. Haz clic en **"Nuevo secreto de cliente"**.
3. Escribe una descripción (ej: `Firebase Auth`) y elige una caducidad (ej: 24 meses). Haz clic en **Agregar**.
4. **IMPORTANTE:** Copia el valor de la columna **"Valor"** (no el ID del secreto). No podrás verlo de nuevo después de cerrar la página.
   - _Este es el valor que debes pegar en el segundo campo de Firebase._

---

## 5. Terminar en Firebase

1. Vuelve a la pestaña de Firebase de tu captura.
2. Pega el **ID de aplicación** y el **Secreto de aplicación**.
3. Mueve el interruptor a **"Habilitar"**.
4. Haz clic en **Guardar**.

---

## 6. Siguiente Paso: Código en Flutter

Para usarlo en la app, necesitarás llamar al proveedor de Microsoft usando el paquete de Firebase Auth:

```dart
final microsoftProvider = MicrosoftAuthProvider();
await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
```
