# 🪟 Guía: Autenticación con Microsoft en Firebase (Refinada)

Para habilitar Microsoft Auth Single-Sign-On (SSO) en FalconByte, Firebase actúa como el proveedor principal de los Tokens. Necesitas registrar la aplicación en **Microsoft Azure (Entra ID)** y pasar las credenciales cruzadas al Dashboard de Google (Firebase).

---

## 1. Crear Aplicación en Microsoft Azure (Entra ID)

1. Ve al [Portal de Azure (App Registrations)](https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade) iniciando sesión con el Administrador Institucional.
2. Haz clic en **"Nuevo registro"** (New registration).
3. Escribe el nombre oficial: `FalconByte-Auth`.
4. En **Tipos de cuenta compatibles**, elige:
   - **Solo inquilino único (Single Tenant):** _(Recomendado para FalconByte)._ Esto restringe el acceso EXCLUSIVAMENTE a las cuentas del dominio oficial tecnológico o escolar. Las cuentas personales (`hotmail.com`, `outlook.com`) serán abofeteadas por Azure con un error si lo intentan.
5. **Dato Clave:** Ve a la sección **"Información general"** y copia el **ID de directorio (inquilino / tenant_id)**. Se requerirá en el código fuente (custom parameters) y en Firebase.
6. Localiza el URI de redirección de Firebase. Normalmente es: `https://[TU-PROYECTO-FIREBASE].firebaseapp.com/__/auth/handler` y asígnalo como tipo **Web**. Pica **Registrar**.

---

## 2. Generar el Secreto del Cliente (Client Secret)

1. En el menú izquierdo de tu app Azure, ve a **"Certificados y secretos"**.
2. Dale a **"Nuevo secreto de cliente"**. Descripción: `Firebase Auth Protocol`. Expiración 24 meses.
3. **Peligro:** Copia exactamente el string listado en la columna **"Valor"** inmediatamente después de que aparezca en pantalla. Una vez recargues, se cifrará con asteriscos permanentemente.
4. Regresa a **"Información general"** y copia el **ID de aplicación (cliente / client_id)**.

---

## 3. Conexión Final (Firebase Console)

1. Entra a "Authentication" en Firebase Console -> Pestaña "Sign-in method" -> Proveedores Adicionales: **Microsoft**.
2. Habilita el switch.
3. Pega el **ID de la aplicación** (Client ID) generado en el paso 2.4.
4. Pega el **Secreto de la aplicación** (Client Secret) generado en el paso 2.3.
5. Guarda. Ya estás listo para autenticar alumnos institucionalmente desde Dart.

_(Para ver la implementación local en nuestro código base, refiérase a `AuthRemoteDataSourceImpl` y sus `customParameters` donde inyectamos el Tenant ID para purgar el selector de correos global)._
