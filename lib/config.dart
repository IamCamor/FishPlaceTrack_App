class AppConfig {
  static const String appName = 'Рыболовный дневник';
  static const String apiBaseUrl = 'https://your-api-domain.com/api';
  static const String mapApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  static const List<String> fishTypes = [
    'Щука', 'Судак', 'Окунь', 'Карп', 'Лещ', 'Плотва',
    'Карась', 'Форель', 'Таймень', 'Сом', 'Жерех', 'Голавль'
  ];
  
  static const List<String> baitTypes = [
    'Червь', 'Опарыш', 'Мотыль', 'Кукуруза', 'Горох', 'Бойлы',
    'Блесна', 'Воблер', 'Поппер', 'Джиг', 'Силикон', 'Мушка'
  ];
  
  static const List<String> weatherTypes = [
    'Солнечно', 'Облачно', 'Дождь', 'Гроза', 'Туман', 'Ветрено', 'Снег'
  ];
}