class FishType {
  final String id;
  final String name;
  final String? latinName;
  final String? description;
  final List<String> photoUrls;
  final String? habitat;
  final String? diet;
  final double? averageWeight;
  final double? maxWeight;
  final double? averageLength;
  final double? maxLength;
  final List<String> regions;
  final String? bestSeason;
  final List<String> recommendedBaits;
  final List<String> recommendedLures;
  final String? fishingTips;
  final bool isGameFish;
  final bool isProtected;
  final DateTime createdAt;
  final DateTime updatedAt;

  FishType({
    required this.id,
    required this.name,
    this.latinName,
    this.description,
    this.photoUrls = const [],
    this.habitat,
    this.diet,
    this.averageWeight,
    this.maxWeight,
    this.averageLength,
    this.maxLength,
    this.regions = const [],
    this.bestSeason,
    this.recommendedBaits = const [],
    this.recommendedLures = const [],
    this.fishingTips,
    this.isGameFish = false,
    this.isProtected = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FishType.fromJson(Map<String, dynamic> json) {
    return FishType(
      id: json['id'],
      name: json['name'],
      latinName: json['latin_name'],
      description: json['description'],
      photoUrls: List<String>.from(json['photo_urls'] ?? []),
      habitat: json['habitat'],
      diet: json['diet'],
      averageWeight: json['average_weight']?.toDouble(),
      maxWeight: json['max_weight']?.toDouble(),
      averageLength: json['average_length']?.toDouble(),
      maxLength: json['max_length']?.toDouble(),
      regions: List<String>.from(json['regions'] ?? []),
      bestSeason: json['best_season'],
      recommendedBaits: List<String>.from(json['recommended_baits'] ?? []),
      recommendedLures: List<String>.from(json['recommended_lures'] ?? []),
      fishingTips: json['fishing_tips'],
      isGameFish: json['is_game_fish'] ?? false,
      isProtected: json['is_protected'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latin_name': latinName,
      'description': description,
      'photo_urls': photoUrls,
      'habitat': habitat,
      'diet': diet,
      'average_weight': averageWeight,
      'max_weight': maxWeight,
      'average_length': averageLength,
      'max_length': maxLength,
      'regions': regions,
      'best_season': bestSeason,
      'recommended_baits': recommendedBaits,
      'recommended_lures': recommendedLures,
      'fishing_tips': fishingTips,
      'is_game_fish': isGameFish,
      'is_protected': isProtected,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}