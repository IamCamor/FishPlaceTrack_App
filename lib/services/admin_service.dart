import '../models/user.dart';
import '../models/report.dart';

class AdminService {
  static Future<List<User>> getUsers() async {
    // В реальном приложении запрос к API
    await Future.delayed(const Duration(seconds: 1));
    return [
      User(
        id: '1',
        name: 'Иван Петров',
        email: 'ivan@example.com',
        totalCatches: 42,
        totalWeight: 125,
      ),
      User(
        id: '2',
        name: 'Мария Сидорова',
        email: 'maria@example.com',
        totalCatches: 28,
        totalWeight: 86,
      ),
    ];
  }

  static Future<List<Report>> getReports() async {
    // В реальном приложении запрос к API
    await Future.delayed(const Duration(seconds: 1));
    return [
      Report(
        id: '1',
        reporterId: 'user1',
        targetId: 'user2',
        type: ReportType.user,
        reason: 'Некорректное поведение',
        createdAt: DateTime.now(),
      ),
      Report(
        id: '2',
        reporterId: 'user3',
        targetId: 'place5',
        type: ReportType.place,
        reason: 'Неверная информация о месте',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  static Future<void> updateUser(User user) async {
    // В реальном приложении запрос к API
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> sendPushNotification(String title, String message) async {
    // В реальном приложении запрос к API
    await Future.delayed(const Duration(seconds: 1));
  }
}