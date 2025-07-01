class YandexConfig {
  // Замените на ваш API ключ Яндекс Карт
  static const String yandexMapKitApiKey = 'YOUR_YANDEX_MAPKIT_API_KEY';
  
  // Настройки по умолчанию для карт
  static const double defaultZoom = 10.0;
  static const double detailZoom = 14.0;
  
  // Центр карты по умолчанию (Москва)
  static const double defaultLatitude = 55.7558;
  static const double defaultLongitude = 37.6176;
  
  // Настройки маркеров
  static const double markerSize = 80.0;
  static const double markerScale = 1.0;
}

// Инструкции по получению API ключа:
// 1. Перейдите на https://developer.tech.yandex.ru/
// 2. Создайте аккаунт или войдите в существующий
// 3. Создайте новое приложение
// 4. Включите API Яндекс.Карт
// 5. Скопируйте API ключ и замените 'YOUR_YANDEX_MAPKIT_API_KEY' выше