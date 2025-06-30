import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    
    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'fishing_channel',
      'Рыболовные уведомления',
      channelDescription: 'Канал для уведомлений о рыбалке',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> showAchievementNotification(Achievement achievement) async {
    await showNotification(
      title: 'Новое достижение!',
      body: 'Вы получили "${achievement.title}": ${achievement.description}',
    );
  }

  static Future<void> showNewCommentNotification(String userName) async {
    await showNotification(
      title: 'Новый комментарий',
      body: '$userName прокомментировал(а) вашу запись',
    );
  }
}