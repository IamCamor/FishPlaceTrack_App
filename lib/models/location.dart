class Location {
  final String id;
  final String name;
  final String? description;
  final double latitude;
  final double longitude;
  final LocationType type;
  final String? ownerId;
  final bool isPrivate;
  final bool isVerified;
  final double rating;
  final int reviewsCount;
  final List<String> photoUrls;
  final Map<String, dynamic>? facilities;
  final String? address;
  final String? region;
  final String? country;
  final List<String> fishTypes;
  final WaterType? waterType;
  final double? depth;
  final DateTime createdAt;
  final DateTime updatedAt;

  Location({
    required this.id,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    this.type = LocationType.fishingSpot,
    this.ownerId,
    this.isPrivate = false,
    this.isVerified = false,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.photoUrls = const [],
    this.facilities,
    this.address,
    this.region,
    this.country,
    this.fishTypes = const [],
    this.waterType,
    this.depth,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      type: LocationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LocationType.fishingSpot,
      ),
      ownerId: json['owner_id'],
      isPrivate: json['is_private'] ?? false,
      isVerified: json['is_verified'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      photoUrls: List<String>.from(json['photo_urls'] ?? []),
      facilities: json['facilities'],
      address: json['address'],
      region: json['region'],
      country: json['country'],
      fishTypes: List<String>.from(json['fish_types'] ?? []),
      waterType: json['water_type'] != null 
          ? WaterType.values.firstWhere(
              (e) => e.name == json['water_type'],
              orElse: () => WaterType.freshwater,
            )
          : null,
      depth: json['depth']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'type': type.name,
      'owner_id': ownerId,
      'is_private': isPrivate,
      'is_verified': isVerified,
      'rating': rating,
      'reviews_count': reviewsCount,
      'photo_urls': photoUrls,
      'facilities': facilities,
      'address': address,
      'region': region,
      'country': country,
      'fish_types': fishTypes,
      'water_type': waterType?.name,
      'depth': depth,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Location copyWith({
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    LocationType? type,
    String? ownerId,
    bool? isPrivate,
    bool? isVerified,
    double? rating,
    int? reviewsCount,
    List<String>? photoUrls,
    Map<String, dynamic>? facilities,
    String? address,
    String? region,
    String? country,
    List<String>? fishTypes,
    WaterType? waterType,
    double? depth,
    DateTime? updatedAt,
  }) {
    return Location(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      ownerId: ownerId ?? this.ownerId,
      isPrivate: isPrivate ?? this.isPrivate,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      photoUrls: photoUrls ?? this.photoUrls,
      facilities: facilities ?? this.facilities,
      address: address ?? this.address,
      region: region ?? this.region,
      country: country ?? this.country,
      fishTypes: fishTypes ?? this.fishTypes,
      waterType: waterType ?? this.waterType,
      depth: depth ?? this.depth,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum LocationType {
  fishingSpot('Место рыбалки', 'fishing_spot'),
  shop('Магазин', 'shop'),
  base('База отдыха', 'base'),
  slip('Слип', 'slip'),
  farm('Рыбная ферма', 'farm'),
  pier('Пирс', 'pier'),
  bridge('Мост', 'bridge'),
  marina('Марина', 'marina');

  const LocationType(this.displayName, this.name);

  final String displayName;
  final String name;
}

enum WaterType {
  freshwater('Пресная вода', 'freshwater'),
  saltwater('Соленая вода', 'saltwater'),
  brackish('Солоноватая вода', 'brackish');

  const WaterType(this.displayName, this.name);

  final String displayName;
  final String name;
}