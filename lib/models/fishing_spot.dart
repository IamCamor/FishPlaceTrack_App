class FishingSpot {
  final String id;
  final String name;
  final String type;
  final String description;
  final double latitude;
  final double longitude;
  final double rating;
  final String? phone;
  final String? website;
  final String? telegram;
  final String imageUrl;

  FishingSpot({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.phone,
    this.website,
    this.telegram,
    required this.imageUrl,
  });

  factory FishingSpot.fromJson(Map<String, dynamic> json) {
    return FishingSpot(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      rating: json['rating'],
      phone: json['phone'],
      website: json['website'],
      telegram: json['telegram'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'phone': phone,
      'website': website,
      'telegram': telegram,
      'imageUrl': imageUrl,
    };
  }
}