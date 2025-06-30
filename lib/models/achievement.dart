class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int progressRequired;
  final AchievementType type;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.progressRequired,
    required this.type,
    this.unlockedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      progressRequired: json['progressRequired'],
      type: AchievementType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AchievementType.general,
      ),
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.parse(json['unlockedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'progressRequired': progressRequired,
      'type': type.toString().split('.').last,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  bool get isUnlocked => unlockedAt != null;
}

enum AchievementType {
  totalCatches, // Общее количество уловов
  bigCatch, // Крупный улов
  speciesMaster, // Мастер по виду рыбы
  consecutiveDays, // Последовательные дни рыбалки
  social, // Социальная активность
  general, // Общие достижения
}