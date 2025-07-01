import 'location.dart';

class FishingLog {
  final String id;
  final String userId;
  final String? title;
  final String? description;
  final DateTime date;
  final Location location;
  final List<FishCatch> catches;
  final List<String> photoUrls;
  final WeatherConditions? weather;
  final List<Equipment> equipment;
  final List<String> companionIds;
  final List<String> tags;
  final bool isPrivate;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  FishingLog({
    required this.id,
    required this.userId,
    this.title,
    this.description,
    required this.date,
    required this.location,
    this.catches = const [],
    this.photoUrls = const [],
    this.weather,
    this.equipment = const [],
    this.companionIds = const [],
    this.tags = const [],
    this.isPrivate = false,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FishingLog.fromJson(Map<String, dynamic> json) {
    return FishingLog(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: Location.fromJson(json['location']),
      catches: (json['catches'] as List?)
          ?.map((catch) => FishCatch.fromJson(catch))
          .toList() ?? [],
      photoUrls: List<String>.from(json['photo_urls'] ?? []),
      weather: json['weather'] != null 
          ? WeatherConditions.fromJson(json['weather']) 
          : null,
      equipment: (json['equipment'] as List?)
          ?.map((eq) => Equipment.fromJson(eq))
          .toList() ?? [],
      companionIds: List<String>.from(json['companion_ids'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      isPrivate: json['is_private'] ?? false,
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location.toJson(),
      'catches': catches.map((catch) => catch.toJson()).toList(),
      'photo_urls': photoUrls,
      'weather': weather?.toJson(),
      'equipment': equipment.map((eq) => eq.toJson()).toList(),
      'companion_ids': companionIds,
      'tags': tags,
      'is_private': isPrivate,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  double get totalWeight {
    return catches.fold(0.0, (sum, catch) => sum + catch.weight);
  }

  int get totalCount {
    return catches.length;
  }
}

class FishCatch {
  final String id;
  final String fishTypeId;
  final String fishTypeName;
  final double weight;
  final double? length;
  final String? bait;
  final String? lure;
  final String? method;
  final List<String> photoUrls;
  final bool isReleased;
  final String? notes;

  FishCatch({
    required this.id,
    required this.fishTypeId,
    required this.fishTypeName,
    required this.weight,
    this.length,
    this.bait,
    this.lure,
    this.method,
    this.photoUrls = const [],
    this.isReleased = false,
    this.notes,
  });

  factory FishCatch.fromJson(Map<String, dynamic> json) {
    return FishCatch(
      id: json['id'],
      fishTypeId: json['fish_type_id'],
      fishTypeName: json['fish_type_name'],
      weight: (json['weight'] ?? 0.0).toDouble(),
      length: json['length']?.toDouble(),
      bait: json['bait'],
      lure: json['lure'],
      method: json['method'],
      photoUrls: List<String>.from(json['photo_urls'] ?? []),
      isReleased: json['is_released'] ?? false,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fish_type_id': fishTypeId,
      'fish_type_name': fishTypeName,
      'weight': weight,
      'length': length,
      'bait': bait,
      'lure': lure,
      'method': method,
      'photo_urls': photoUrls,
      'is_released': isReleased,
      'notes': notes,
    };
  }
}

class WeatherConditions {
  final double temperature;
  final String description;
  final double windSpeed;
  final String windDirection;
  final int humidity;
  final double pressure;
  final String skyCondition;

  WeatherConditions({
    required this.temperature,
    required this.description,
    required this.windSpeed,
    required this.windDirection,
    required this.humidity,
    required this.pressure,
    required this.skyCondition,
  });

  factory WeatherConditions.fromJson(Map<String, dynamic> json) {
    return WeatherConditions(
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      windSpeed: (json['wind_speed'] ?? 0.0).toDouble(),
      windDirection: json['wind_direction'] ?? '',
      humidity: json['humidity'] ?? 0,
      pressure: (json['pressure'] ?? 0.0).toDouble(),
      skyCondition: json['sky_condition'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'description': description,
      'wind_speed': windSpeed,
      'wind_direction': windDirection,
      'humidity': humidity,
      'pressure': pressure,
      'sky_condition': skyCondition,
    };
  }
}

class Equipment {
  final String id;
  final String name;
  final String type;
  final String? brand;
  final String? model;
  final String? description;

  Equipment({
    required this.id,
    required this.name,
    required this.type,
    this.brand,
    this.model,
    this.description,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      brand: json['brand'],
      model: json['model'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'brand': brand,
      'model': model,
      'description': description,
    };
  }
}