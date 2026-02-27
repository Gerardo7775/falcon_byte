/// Validadores para formularios
class Validators {
  /// Valida un email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }

    return null;
  }

  /// Valida una contraseña
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    return null;
  }

  /// Valida un campo requerido
  static String? required(String? value, [String fieldName = 'Este campo']) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  /// Valida un número de teléfono
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Opcional
    }

    final phoneRegex = RegExp(r'^\d{10}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Ingresa un número de teléfono válido (10 dígitos)';
    }

    return null;
  }

  /// Valida un precio
  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return 'El precio es requerido';
    }

    final price = double.tryParse(value);

    if (price == null || price <= 0) {
      return 'Ingresa un precio válido';
    }

    return null;
  }
}
