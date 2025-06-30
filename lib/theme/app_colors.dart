import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF32B5B0); // Основной бирюзовый
  static const Color secondary = Color(0xFF1F3B5C); // Темно-синий
  static const Color background = Color(0xFFF7F3EB); // Светло-бежевый фон
  static const Color surface = Color(0xFFFFFFFF); // Белый для карточек
  static const Color onPrimary = Color(0xFFFFFFFF); // Белый на основном
  static const Color onSecondary = Color(0xFFFFFFFF); // Белый на вторичном
  static const Color text = Color(0xFF333333); // Основной текст
  static const Color textSecondary = Color(0xFF6E7B8B); // Вторичный текст
  static const Color accent = Color(0xFFF9A825); // Акцентный желтый
  static const Color error = Color(0xFFE53935); // Ошибка
  static const Color success = Color(0xFF43A047); // Успех
  static const Color warning = Color(0xFFFFB300); // Предупреждение
  static const Color divider = Color(0xFFE0E0E0); // Разделитель
  
  // Цвета для уровней пользователей
  static const Map<int, Color> levelColors = {
    1: Color(0xFF9E9E9E), // Серый
    2: Color(0xFF4CAF50), // Зеленый
    3: Color(0xFF2196F3), // Синий
    4: Color(0xFFFFC107), // Янтарный
    5: Color(0xFFF44336), // Красный
  };

  // Цвета для типов рыб
  static const Map<String, Color> fishTypeColors = {
    'Щука': Color(0xFF4CAF50),
    'Судак': Color(0xFF2196F3),
    'Окунь': Color(0xFFFFC107),
    'Карп': Color(0xFFFF9800),
    'Форель': Color(0xFFE91E63),
    'Таймень': Color(0xFF9C27B0),
  };

  // Градиенты
  static Gradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF29A19C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}