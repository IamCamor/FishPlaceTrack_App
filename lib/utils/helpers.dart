import 'package:intl/intl.dart';
import '../models/fishing_entry.dart';
import '../utils/constants.dart';

class Helpers {
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat.yMMMd().add_Hm().format(date);
  }

  static String getFishTypeName(String type) {
    return AppConstants.fishTypes.contains(type) 
        ? type 
        : 'Другая рыба';
  }

  static String getBaitTypeName(String type) {
    return AppConstants.baitTypes.contains(type) 
        ? type 
        : 'Другая приманка';
  }

  static String getTackleTypeName(String type) {
    return AppConstants.tackleTypes.contains(type) 
        ? type 
        : 'Другие снасти';
  }

  static String getWeatherTypeName(String type) {
    return AppConstants.weatherTypes.contains(type) 
        ? type 
        : 'Другая погода';
  }

  static double calculateAverageWeight(List<FishingEntry> entries) {
    if (entries.isEmpty) return 0.0;
    final total = entries.fold(0.0, (sum, entry) => sum + entry.weight);
    return total / entries.length;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return 'Введите корректный email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 6) {
      return 'Пароль должен быть не менее 6 символов';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }
    if (value != password) {
      return 'Пароли не совпадают';
    }
    return null;
  }
}