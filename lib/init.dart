import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/user_provider.dart';
import '../services/entry_provider.dart';

Future<void> initApp(BuildContext context) async {
  // Инициализация SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Инициализация сервисов
  final authService = Provider.of<AuthService>(context, listen: false);
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final entryProvider = Provider.of<EntryProvider>(context, listen: false);
  
  // Проверка аутентификации
  final token = prefs.getString('authToken');
  if (token != null) {
    // Загрузка данных пользователя
    final user = await authService.loadUserData();
    if (user != null) {
      userProvider.setCurrentUser(user);
      
      // Загрузка друзей
      final friends = await authService.loadFriends();
      userProvider.setFriends(friends);
      
      // Загрузка записей
      await entryProvider.refreshEntries();
    }
  }
}
