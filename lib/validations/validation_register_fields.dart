class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Будь ласка, введіть ім'я";
    }
    if (value.length < 3) {
      return "Ім'я має містити щонайменше 3 символи";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Будь ласка, введіть email';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Введіть коректний email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Будь ласка, введіть пароль';
    }
    if (value.length < 6) {
      return 'Пароль має бути мінімум 6 символів';
    }
    return null;
  }
}
