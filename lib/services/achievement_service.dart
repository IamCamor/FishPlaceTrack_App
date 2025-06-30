import '../models/achievement.dart';
import '../services/api_service.dart';

class AchievementService {
  static final List<Achievement> allAchievements = [
    // Награды за количество рыбалок
    Achievement(
      id: '10_fishing',
      title: 'Новичок',
      description: '10 рыбалок',
      icon: '🎣',
      progressRequired: 10,
      type: AchievementType.totalCatches,
    ),
    Achievement(
      id: '50_fishing',
      title: 'Опытный рыболов',
      description: '50 рыбалок',
      icon: '🏆',
      progressRequired: 50,
      type: AchievementType.totalCatches,
    ),
    Achievement(
      id: '100_fishing',
      title: 'Мастер рыбалки',
      description: '100 рыбалок',
      icon: '👑',
      progressRequired: 100,
      type: AchievementType.totalCatches,
    ),
    
    // Награды за крупный улов
    Achievement(
      id: 'big_catch_5kg',
      title: 'Крупная добыча',
      description: 'Рыба более 5 кг',
      icon: '🐟',
      progressRequired: 1,
      type: AchievementType.bigCatch,
    ),
    
    // Награды за виды рыб
    Achievement(
      id: 'pike_master',
      title: 'Мастер щуки',
      description: '10 щук',
      icon: '🦈',
      progressRequired: 10,
      type: AchievementType.speciesMaster,
    ),
  ];

  static Future<List<Achievement>> getUserAchievements(String userId) async {
    // В реальном приложении - запрос к API
    return allAchievements.where((a) => a.id == '10_fishing' || a.id == 'big_catch_5kg').toList();
  }

  static Future<void> awardAchievement(String userId, String achievementId) async {
    await ApiService.awardAchievement(userId, achievementId);
  }

  static Future<void> checkForNewAchievements(String userId, int totalCatches) async {
    final unlocked = allAchievements.where(
      (a) => a.type == AchievementType.totalCatches && 
          totalCatches >= a.progressRequired
    );
    
    for (final achievement in unlocked) {
      await awardAchievement(userId, achievement.id);
    }
  }
}