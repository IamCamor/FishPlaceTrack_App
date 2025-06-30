class FishingEntry {
  final String? id;
  final String userId;
  final DateTime date;
  final String location;
  final double latitude;
  final double longitude;
  final String fishType;
  final double weight;
  final double? length;
  final String bait;
  final String tackle;
  final String weather;
  final String notes;
  final String? photoUrl;
  final bool isPublic;
  final double rating;
  final List<String> companionIds;
  final int likesCount;
  final int commentsCount;
  final int shareCount;

  FishingEntry({
    this.id,
    required this.userId,
    required this.date,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.fishType,
    required this.weight,
    this.length,
    required this.bait,
    required this.tackle,
    required this.weather,
    required this.notes,
    this.photoUrl,
    this.isPublic = true,
    this.rating = 0.0,
    this.companionIds = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.shareCount = 0,
  });

  factory FishingEntry.fromJson(Map<String, dynamic> json) {
    return FishingEntry(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      fishType: json['fishType'],
      weight: json['weight'],
      length: json['length'],
      bait: json['bait'],
      tackle: json['tackle'],
      weather: json['weather'],
      notes: json['notes'],
      photoUrl: json['photoUrl'],
      isPublic: json['isPublic'],
      rating: json['rating'],
      companionIds: List<String>.from(json['companionIds'] ?? []),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'fishType': fishType,
      'weight': weight,
      'length': length,
      'bait': bait,
      'tackle': tackle,
      'weather': weather,
      'notes': notes,
      'photoUrl': photoUrl,
      'isPublic': isPublic,
      'rating': rating,
      'companionIds': companionIds,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'shareCount': shareCount,
    };
  }
}