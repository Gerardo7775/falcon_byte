# Guía de Entorno de Desarrollo (Setup)

Bienvenido(a) a FalconByte. Para sumarte al desarrollo o compilación del proyecto de forma local, sigue estos pasos preparativos.

## 🛠️ Herramientas Requeridas

1. **Flutter SDK**: Necesitas la última versión estable (>= 3.19.0). [Instálelo aquí](https://docs.flutter.dev/get-started/install).
2. **Dart SDK**: Integrado en el SDK de Flutter (>= 3.3.0).
3. **IDE Recomendado**: Visual Studio Code o Android Studio.
   - Si usas VS Code, instala las extensiones oficiales: `Flutter`, `Dart` y recomendablemente `Bloc` de Felix Angelov.
4. **Git**: Para clonar el repositorio y manejar ramas.

## 📱 Configuración de Emuladores

- **Para Android**: Instala Android Studio, ve al "Device Manager", crea un dispositivo virtual usando preferiblemente una imagen de hardware reciente (API 34 o superior) con la Play Store incluida.
- **Para iOS (Solo Mac)**: Instala Xcode desde la Mac App Store, abre Xcode al menos una vez para aceptar términos e instala las herramientas de comando ejecutando `xcode-select --install`.

## ⚙️ Pasos de Instalación del Proyecto

1. Clona el repositorio a tu máquina local:

   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd falcon_byte
   ```

2. Descarga de dependencias:

   ```bash
   flutter pub get
   ```

3. **Autenticación en la Nube (Solo si compilas tus propios servicios de validación Firebase)**:
   Si tienes un problema de "Servicio de Google no encontrado", pídele al Administrador del proyecto (Tech Lead) los archivos secretos de configuración:
   - Para Android: Pega el archivo proporcionado `google-services.json` en `android/app/`.
   - Para iOS: Pega el archivo proporcionado `GoogleService-Info.plist` en `ios/Runner/`.

4. Construcción Nativa (opcional):
   En iOS, hay que descargar las dependencias nativas del CocoaPods:

   ```bash
   cd ios
   pod install
   cd ..
   ```

5. Arranca la aplicación (conecta USB a un físico o enciende el emulador):
   ```bash
   flutter run
   ```

## 🐛 Troubleshooting Rápido

- **`CocoaPods not installed`:** Instálalo mediante `sudo gem install cocoapods` o Homebrew.
- **Conflictos BLoC/Generadores:** Ocasionalmente si hay conflictos de caché en el Analizador, prueba limpiar con `flutter clean` seguido de un `flutter pub get`.
