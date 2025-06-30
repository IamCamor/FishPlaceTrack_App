class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final List<String> roles;
  final int level;
  final int experience;
  final List<String> favoriteBrands;
  final List<String> favoriteBaits;
  final bool isGuide;
  final bool isBanned;
  final int totalCatches;
  final int totalWeight;
  final int achievementsCount;
  final bool hasMonthlyGoldBadge;
  final DateTime? goldBadgeExpiration;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.roles = const ['user'],
    this.level = 1,
    this.experience = 0,
    this.favoriteBrands = const [],
    this.favoriteBaits = const [],
    this.isGuide = false,
    this.isBanned = false,
    this.totalCatches = 0,
    this.totalWeight = 0,
    this.achievementsCount = 0,
    this.hasMonthlyGoldBadge = false,
    this.goldBadgeExpiration,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      roles: List<String>.from(json['roles']),
      level: json['level'],
      experience: json['experience'],
      favoriteBrands: List<String>.from(json['favoriteBrands']),
      favoriteBaits: List<String>.from(json['favoriteBaits']),
      isGuide: json['isGuide'],
      isBanned: json['isBanned'],
      totalCatches: json['totalCatches'],
      totalWeight: json['totalWeight'],
      achievementsCount: json['achievementsCount'],
      hasMonthlyGoldBadge: json['hasMonthlyGoldBadge'],
      goldBadgeExpiration: json['goldBadgeExpiration'] != null
          ? DateTime.parse(json['goldBadgeExpiration'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'roles': roles,
      'level': level,
      'experience': experience,
      'favoriteBrands': favoriteBrands,
      'favoriteBaits': favoriteBaits,
      'isGuide': isGuide,
      'isBanned': isBanned,
      'totalCatches': totalCatches,
      'totalWeight': totalWeight,
      'achievementsCount': achievementsCount,
      'hasMonthlyGoldBadge': hasMonthlyGoldBadge,
      'goldBadgeExpiration': goldBadgeExpiration?.toIso8601String(),
    };
  }
}