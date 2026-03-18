import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta de colores institucional FalconByte — Edición Premium
class AppColors {
  // Primarios
  static const Color primary = Color(0xFF1A3A6B);
  static const Color primaryLight = Color(0xFF2E5EA8);
  static const Color primaryDark = Color(0xFF0D2244);
  static const Color accent = Color(0xFF00AAFF);
  static const Color accentVibrant = Color(0xFF00D4FF);

  // Gradientes
  static const Color gradientStart = Color(0xFF1A3A6B);
  static const Color gradientMid = Color(0xFF1A5FA8);
  static const Color gradientEnd = Color(0xFF00AAFF);
  static const Color gradientDarkStart = Color(0xFF0A1628);
  static const Color gradientDarkEnd = Color(0xFF0D2F5E);

  // Glass
  static const Color glassLight = Color(0xBBFFFFFF);
  static const Color glassDark = Color(0x22FFFFFF);
  static const Color glassBorderLight = Color(0x55FFFFFF);
  static const Color glassBorderDark = Color(0x22FFFFFF);

  // Superficies — Claro
  static const Color bgLight = Color(0xFFF0F4FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFEAEEF7);

  // Superficies — Oscuro
  static const Color bgDark = Color(0xFF080D18);
  static const Color surfaceDark = Color(0xFF0F1623);
  static const Color surfaceVariantDark = Color(0xFF161E30);
  static const Color surfaceElevatedDark = Color(0xFF1A2540);

  // Texto — Claro
  static const Color textPrimaryLight = Color(0xFF0D1B2E);
  static const Color textSecondaryLight = Color(0xFF5A6880);

  // Texto — Oscuro
  static const Color textPrimaryDark = Color(0xFFE8EDF5);
  static const Color textSecondaryDark = Color(0xFF8A9BBB);

  // Estado
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Avatares (paleta para generar colores únicos por inicial)
  static const List<Color> avatarColors = [
    Color(0xFF6366F1), // índigo
    Color(0xFF8B5CF6), // violeta
    Color(0xFFEC4899), // rosa
    Color(0xFFEF4444), // rojo
    Color(0xFFF97316), // naranja
    Color(0xFF10B981), // esmeralda
    Color(0xFF06B6D4), // cyan
    Color(0xFF3B82F6), // azul
  ];

  /// Retorna un color de avatar basado en el nombre del usuario
  static Color avatarColorFor(String name) {
    if (name.isEmpty) return avatarColors[0];
    final index = name.codeUnitAt(0) % avatarColors.length;
    return avatarColors[index];
  }
}

/// Gradientes reutilizables
class AppGradients {
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.gradientStart, AppColors.gradientMid, AppColors.gradientEnd],
  );

  static const LinearGradient primaryDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.gradientDarkStart, AppColors.gradientDarkEnd],
  );

  static const LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E5EA8), Color(0xFF00AAFF)],
  );

  static const LinearGradient bubble = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E5EA8), Color(0xFF00AAFF)],
  );

  static const LinearGradient card = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A3A6B), Color(0xFF0D2244)],
  );
}

/// Configuración central de temas de FalconByte — Premium Edition
class AppTheme {
  // Compatibilidad con código existente
  static const Color primaryColor = AppColors.primary;
  static const Color secondaryColor = AppColors.primaryDark;
  static const Color accentColor = AppColors.accent;
  static const Color backgroundColor = AppColors.bgLight;
  static const Color surfaceColor = AppColors.surfaceLight;
  static const Color textPrimaryColor = AppColors.textPrimaryLight;
  static const Color textSecondaryColor = AppColors.textSecondaryLight;
  static const Color successColor = AppColors.success;
  static const Color warningColor = AppColors.warning;
  static const Color errorColor = AppColors.error;
  static const Color infoColor = AppColors.info;

  /// ─── Tema Claro ────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.surfaceVariantLight,
        secondary: AppColors.accent,
        surface: AppColors.surfaceLight,
        surfaceContainerHighest: AppColors.surfaceVariantLight,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
        onSurfaceVariant: AppColors.textSecondaryLight,
        error: AppColors.error,
      ),
      textTheme: _buildTextTheme(AppColors.textPrimaryLight, AppColors.textSecondaryLight),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimaryLight,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
          letterSpacing: -0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD1D9E6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFD1D9E6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondaryLight),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondaryLight),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE2E8F4)),
        ),
        color: AppColors.surfaceLight,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight.withValues(alpha: 0.9),
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textSecondaryLight, size: 24);
        }),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFE8EDF5), thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantLight,
        labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimaryLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// ─── Tema Oscuro ───────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.accentVibrant,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentVibrant,
        primaryContainer: AppColors.surfaceVariantDark,
        secondary: AppColors.accent,
        surface: AppColors.surfaceDark,
        surfaceContainerHighest: AppColors.surfaceVariantDark,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimaryDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        error: AppColors.error,
      ),
      textTheme: _buildTextTheme(AppColors.textPrimaryDark, AppColors.textSecondaryDark),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimaryDark,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
          letterSpacing: -0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentVibrant,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentVibrant,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2A3550)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2A3550)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accentVibrant, width: 2),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondaryDark),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondaryDark),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1E2A40)),
        ),
        color: AppColors.surfaceDark,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark.withValues(alpha: 0.85),
        indicatorColor: AppColors.accentVibrant.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.accentVibrant, size: 24);
          }
          return const IconThemeData(color: AppColors.textSecondaryDark, size: 24);
        }),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFF1A2438), thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantDark,
        labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimaryDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// ─── Tipografía compartida ──────────────────────────────────────────────────
  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: primary, letterSpacing: -1.0),
      displayMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: primary, letterSpacing: -0.8),
      displaySmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: primary, letterSpacing: -0.5),
      headlineLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.3),
      headlineMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: primary, letterSpacing: -0.2),
      headlineSmall: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: primary),
      titleLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: primary),
      titleMedium: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: primary),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, color: primary),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: primary),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal, color: secondary),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: primary),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: secondary),
    );
  }
}
