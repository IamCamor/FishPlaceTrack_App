class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserLevel level;
  final int totalCatches;
  final double totalWeight;
  final List<String> favoriteBrands;
  final Map<String, dynamic>? settings;
  final bool isVerified;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    required this.createdAt,
    this.lastLoginAt,
    this.level = UserLevel.novice,
    this.totalCatches = 0,
    this.totalWeight = 0.0,
    this.favoriteBrands = const [],
    this.settings,
    this.isVerified = false,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['display_name'],
      photoURL: json['photo_url'],
      phoneNumber: json['phone_number'],
      createdAt: DateTime.parse(json['created_at']),
      lastLoginAt: json['last_login_at'] != null 
          ? DateTime.parse(json['last_login_at']) 
          : null,
      level: UserLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => UserLevel.novice,
      ),
      totalCatches: json['total_catches'] ?? 0,
      totalWeight: (json['total_weight'] ?? 0.0).toDouble(),
      favoriteBrands: List<String>.from(json['favorite_brands'] ?? []),
      settings: json['settings'],
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'photo_url': photoURL,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'level': level.name,
      'total_catches': totalCatches,
      'total_weight': totalWeight,
      'favorite_brands': favoriteBrands,
      'settings': settings,
      'is_verified': isVerified,
      'is_active': isActive,
    };
  }

  User copyWith({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    DateTime? lastLoginAt,
    UserLevel? level,
    int? totalCatches,
    double? totalWeight,
    List<String>? favoriteBrands,
    Map<String, dynamic>? settings,
    bool? isVerified,
    bool? isActive,
  }) {
    return User(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      level: level ?? this.level,
      totalCatches: totalCatches ?? this.totalCatches,
      totalWeight: totalWeight ?? this.totalWeight,
      favoriteBrands: favoriteBrands ?? this.favoriteBrands,
      settings: settings ?? this.settings,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum UserLevel {
  novice('Новичок', 'novice'),
  guide('Гид', 'guide'),
  pro('Профи', 'pro'),
  top('Топ', 'top');

  const UserLevel(this.displayName, this.name);

  final String displayName;
  final String name;
}