# 🎣 FishTrack

**FishTrack** — мобильное и веб-приложение для рыбаков, объединяющее функции дневника рыбалок, социальной сети, карты рыболовных мест и базы знаний.

## 📱 Возможности

### 🏠 Основной функционал
- **Дневник рыбалок** — записи с фотографиями, описанием улова, местом, погодными условиями
- **Интерактивная карта** — рыболовные места, магазины, базы отдыха, слипы
- **Социальная сеть** — лайки, комментарии, подписки, рейтинги рыбаков
- **Каталог рыб** — справочник с фотографиями, описаниями, рекомендациями
- **Узлы** — пошаговые инструкции по вязанию рыболовных узлов

### 🌟 Дополнительные функции
- **Клубы** — создание и участие в рыболовных сообществах
- **События и соревнования** — планирование и участие в мероприятиях
- **Рейтинги** — топ рыбаков, лучшие места, рыбалки дня/недели
- **Push-уведомления** — о новых уловах, комментариях, событиях
- **Многоязычность** — поддержка русского и английского языков

## 🛠 Технологии

### Frontend (Mobile + Web)
- **Flutter** — кроссплатформенная разработка
- **Material Design 3** — современный дизайн
- **Provider** — управление состоянием
- **Firebase Auth** — аутентификация
- **Яндекс.Карты** — интерактивные карты
- **Dio** — HTTP клиент

### Backend
- **Laravel** (рекомендуемый) или PHP REST API
- **MySQL** — база данных
- **Firebase** — push-уведомления, аутентификация
- **S3/Local Storage** — хранение файлов

### Сервисы
- **Google Sign-In** — вход через Google
- **Apple Sign-In** — вход через Apple (iOS)
- **Яндекс.MapKit API** — карты и геолокация
- **Weather API** — погодные данные

## 🚀 Быстрый старт

### Требования
- Flutter SDK 3.8.1+
- Dart 3.0+
- Android Studio / Xcode
- Firebase проект

### Установка

1. **Клонирование репозитория**
```bash
git clone https://github.com/yourusername/fishtrack.git
cd fishtrack
```

2. **Установка зависимостей**
```bash
flutter pub get
```

3. **Настройка Firebase**
```bash
# Установка Firebase CLI
npm install -g firebase-tools

# Настройка проекта
flutterfire configure
```

4. **Настройка API ключей**
Откройте файл `lib/config/yandex_config.dart` и укажите ваш API ключ Яндекс.Карт:
```dart
static const String yandexMapKitApiKey = 'ваш_api_ключ_яндекс_карт';
```

Создайте файл `.env` в корне проекта:
```env
API_BASE_URL=https://api.fishtrack.app
```

5. **Запуск приложения**
```bash
flutter run
```

## 📁 Структура проекта

```
lib/
├── main.dart                 # Точка входа
├── models/                   # Модели данных
│   ├── user.dart
│   ├── fishing_log.dart
│   ├── location.dart
│   ├── fish_type.dart
│   ├── knot.dart
│   └── club.dart
├── services/                 # Сервисы
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── location_service.dart
├── screens/                  # Экраны
│   ├── main_screen.dart
│   ├── home/
│   ├── map/
│   ├── add_fishing/
│   ├── catalog/
│   ├── profile/
│   └── auth/
├── widgets/                  # Виджеты
│   ├── fishing_log_card.dart
│   ├── location_bottom_sheet.dart
│   └── shimmer_loading.dart
├── theme/                    # Темы
│   └── app_theme.dart
└── utils/                    # Утилиты
    └── constants.dart
```

## 🎨 Дизайн система

### Цветовая палитра
- **Основной**: `#00A3AD` (бирюзовый)
- **Дополнительный**: `#0B3D91` (синий)
- **Фон**: `#F5F5F5` (светло-серый)
- **Поверхность**: `#FFFFFF` (белый)
- **Акцент**: `#292D32` (темно-серый)

### Типографика
- **Шрифт**: Inter
- **Размеры**: от 10px до 32px
- **Начертания**: Regular, Medium, SemiBold, Bold

## 🌍 API Структура

### Эндпоинты

#### Аутентификация
```
POST /api/auth/login
POST /api/auth/register
POST /api/auth/logout
POST /api/auth/refresh
```

#### Рыбалки
```
GET    /api/fishing-logs
POST   /api/fishing-logs
PUT    /api/fishing-logs/{id}
DELETE /api/fishing-logs/{id}
POST   /api/fishing-logs/{id}/like
```

#### Места
```
GET    /api/locations
POST   /api/locations
GET    /api/locations/{id}
PUT    /api/locations/{id}
```

#### Пользователи
```
GET    /api/user/profile
PUT    /api/user/profile
GET    /api/users/search
GET    /api/rankings
```

### Пример ответа API
```json
{
  "data": {
    "id": "123",
    "title": "Утренняя рыбалка",
    "date": "2024-01-15T06:00:00Z",
    "location": {
      "id": "456",
      "name": "Озеро Сенеж",
      "latitude": 56.123,
      "longitude": 37.456
    },
    "catches": [
      {
        "fish_type": "Окунь",
        "weight": 1.5,
        "length": 25.0
      }
    ]
  }
}
```

## 🔧 Конфигурация

### Firebase
```json
{
  "project_id": "fishtrack-app",
  "services": {
    "authentication": true,
    "firestore": false,
    "storage": true,
    "messaging": true
  }
}
```

### Яндекс.Карты
Получите API ключ на [developer.tech.yandex.ru](https://developer.tech.yandex.ru/) и укажите его в `lib/config/yandex_config.dart`.

Подробная инструкция по настройке находится в файле `YANDEX_MAPS_SETUP.md`.

## 📱 Сборка

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🧪 Тестирование

```bash
# Unit тесты
flutter test

# Integration тесты
flutter test integration_test/

# Покрытие кода
flutter test --coverage
```

## 📈 Деплой

### Web (Firebase Hosting)
```bash
flutter build web
firebase deploy --only hosting
```

### Mobile (Store)
```bash
# Android (Google Play)
flutter build appbundle
# Загрузка через Play Console

# iOS (App Store)
flutter build ios
# Загрузка через App Store Connect
```

## 📊 Аналитика

- **Firebase Analytics** — пользовательские события
- **Google Analytics** — веб-трафик
- **Crashlytics** — отслеживание ошибок

### События
```dart
// Примеры событий
analytics.logEvent('fishing_log_created');
analytics.logEvent('location_added');
analytics.logEvent('user_registered');
```

## 🔐 Безопасность

- JWT токены для API
- Firebase Security Rules
- Валидация данных на клиенте и сервере
- Шифрование чувствительных данных

## 🌐 Локализация

### Поддерживаемые языки
- 🇷🇺 Русский (основной)
- 🇺🇸 Английский

### Файлы локализации
```
assets/lang/
├── ru.json
└── en.json
```

## 📄 Лицензия

MIT License - подробности в файле [LICENSE](LICENSE)

## 👥 Команда

- **Frontend Developer** — Flutter разработка
- **Backend Developer** — API и база данных
- **UI/UX Designer** — дизайн и пользовательский опыт
- **QA Engineer** — тестирование

## 🤝 Вклад в проект

1. Fork репозитория
2. Создайте feature branch (`git checkout -b feature/amazing-feature`)
3. Commit изменения (`git commit -m 'Add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Создайте Pull Request

## 📞 Поддержка

- **Email**: support@fishtrack.app
- **Telegram**: @fishtrack_support
- **GitHub Issues**: [Issues](https://github.com/yourusername/fishtrack/issues)

## 🗺 Roadmap

### v1.0 (Текущая)
- ✅ Базовый функционал
- ✅ Аутентификация
- ✅ CRUD операции
- ✅ Карта мест

### v1.1
- 🔄 Клубы и события
- 🔄 Push-уведомления
- 🔄 Расширенная аналитика

### v2.0
- 📋 Telegram Bot
- 📋 Интеграции с магазинами
- 📋 AR функции
- 📋 Машинное обучение

---

Made with ❤️ for fishing community
