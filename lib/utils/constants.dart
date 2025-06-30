class AppConstants {
  static const String appName = 'Рыболовный дневник';
  static const String appVersion = '1.0.0';
  
  // API конфигурация
  static const String apiBaseUrl = 'https://your-api-domain.com/api';
  static const String mapApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  // Типы рыболовных мест
  static const List<String> spotTypes = [
    'Река', 'Озеро', 'Пруд', 'Водохранилище', 'Море', 'Канал'
  ];
  
  // Виды рыб
  static const List<String> fishTypes = [
    'Щука', 'Судак', 'Окунь', 'Карп', 'Лещ', 'Плотва',
    'Карась', 'Форель', 'Таймень', 'Сом', 'Жерех', 'Голавль'
  ];
  
  // Типы приманок
  static const List<String> baitTypes = [
    'Червь', 'Опарыш', 'Мотыль', 'Кукуруза', 'Горох', 'Бойлы',
    'Блесна', 'Воблер', 'Поппер', 'Джиг', 'Силикон', 'Мушка'
  ];
  
  // Типы снастей
  static const List<String> tackleTypes = [
    'Удочка', 'Спиннинг', 'Фидер', 'Донка', 'Нахлыст', 'Кружки'
  ];
  
  // Типы погоды
  static const List<String> weatherTypes = [
    'Солнечно', 'Облачно', 'Дождь', 'Гроза', 'Туман', 'Ветрено', 'Снег'
  ];
}