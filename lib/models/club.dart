class Club {
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String ownerId;
  final List<String> adminIds;
  final List<String> memberIds;
  final int memberCount;
  final bool isPrivate;
  final bool isVerified;
  final String? region;
  final String? country;
  final List<String> tags;
  final Map<String, dynamic>? settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  Club({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    required this.ownerId,
    this.adminIds = const [],
    this.memberIds = const [],
    this.memberCount = 0,
    this.isPrivate = false,
    this.isVerified = false,
    this.region,
    this.country,
    this.tags = const [],
    this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logoUrl: json['logo_url'],
      ownerId: json['owner_id'],
      adminIds: List<String>.from(json['admin_ids'] ?? []),
      memberIds: List<String>.from(json['member_ids'] ?? []),
      memberCount: json['member_count'] ?? 0,
      isPrivate: json['is_private'] ?? false,
      isVerified: json['is_verified'] ?? false,
      region: json['region'],
      country: json['country'],
      tags: List<String>.from(json['tags'] ?? []),
      settings: json['settings'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo_url': logoUrl,
      'owner_id': ownerId,
      'admin_ids': adminIds,
      'member_ids': memberIds,
      'member_count': memberCount,
      'is_private': isPrivate,
      'is_verified': isVerified,
      'region': region,
      'country': country,
      'tags': tags,
      'settings': settings,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool isOwner(String userId) => ownerId == userId;
  bool isAdmin(String userId) => adminIds.contains(userId) || isOwner(userId);
  bool isMember(String userId) => memberIds.contains(userId) || isAdmin(userId);
}

class ClubEvent {
  final String id;
  final String clubId;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final String? locationId;
  final String? locationName;
  final EventType type;
  final List<String> participantIds;
  final int maxParticipants;
  final bool isPublic;
  final Map<String, dynamic>? rules;
  final Map<String, dynamic>? prizes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClubEvent({
    required this.id,
    required this.clubId,
    required this.title,
    this.description,
    required this.startDate,
    this.endDate,
    this.locationId,
    this.locationName,
    required this.type,
    this.participantIds = const [],
    this.maxParticipants = 0,
    this.isPublic = true,
    this.rules,
    this.prizes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClubEvent.fromJson(Map<String, dynamic> json) {
    return ClubEvent(
      id: json['id'],
      clubId: json['club_id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date']) 
          : null,
      locationId: json['location_id'],
      locationName: json['location_name'],
      type: EventType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EventType.fishing,
      ),
      participantIds: List<String>.from(json['participant_ids'] ?? []),
      maxParticipants: json['max_participants'] ?? 0,
      isPublic: json['is_public'] ?? true,
      rules: json['rules'],
      prizes: json['prizes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'club_id': clubId,
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'location_id': locationId,
      'location_name': locationName,
      'type': type.name,
      'participant_ids': participantIds,
      'max_participants': maxParticipants,
      'is_public': isPublic,
      'rules': rules,
      'prizes': prizes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

enum EventType {
  fishing('Рыбалка', 'fishing'),
  competition('Соревнование', 'competition'),
  meeting('Встреча', 'meeting'),
  workshop('Мастер-класс', 'workshop');

  const EventType(this.displayName, this.name);

  final String displayName;
  final String name;
}