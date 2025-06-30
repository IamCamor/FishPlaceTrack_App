import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Язык'),
            subtitle: const Text('Русский'),
            onTap: () => _changeLanguage(context),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Темная тема'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Уведомления'),
            onTap: () => _notificationSettings(context),
          ),
          ListTile(
            leading: const Icon(Icons.fishing),
            title: const Text('Снасти и приманки'),
            onTap: () => _manageTackle(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Помощь и поддержка'),
            onTap: () => _showHelp(context),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Условия использования'),
            onTap: () => _showTerms(context),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Политика конфиденциальности'),
            onTap: () => _showPrivacyPolicy(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Выйти'),
            onTap: () => authService.logout(),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Версия приложения: ${AppConstants.appVersion}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _changeLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите язык'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Русский'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('English'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _notificationSettings(BuildContext context) {
    // Реализация экрана настроек уведомлений
  }

  void _manageTackle(BuildContext context) {
    // Реализация управления снастями и приманками
  }

  void _showHelp(BuildContext context) {
    // Реализация показа помощи
  }

  void _showTerms(BuildContext context) {
    // Реализация показа условий использования
  }

  void _showPrivacyPolicy(BuildContext context) {
    // Реализация показа политики конфиденциальности
  }
}