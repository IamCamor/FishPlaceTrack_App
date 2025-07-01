class Knot {
  final String id;
  final String name;
  final String? description;
  final String category;
  final int difficulty; // 1-5 scale
  final double strength; // 0-1 scale
  final List<KnotStep> steps;
  final List<String> uses;
  final List<String> advantages;
  final List<String> disadvantages;
  final String? videoUrl;
  final List<String> photoUrls;
  final bool isPopular;
  final DateTime createdAt;
  final DateTime updatedAt;

  Knot({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.difficulty,
    required this.strength,
    this.steps = const [],
    this.uses = const [],
    this.advantages = const [],
    this.disadvantages = const [],
    this.videoUrl,
    this.photoUrls = const [],
    this.isPopular = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Knot.fromJson(Map<String, dynamic> json) {
    return Knot(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      difficulty: json['difficulty'] ?? 1,
      strength: (json['strength'] ?? 0.0).toDouble(),
      steps: (json['steps'] as List?)
          ?.map((step) => KnotStep.fromJson(step))
          .toList() ?? [],
      uses: List<String>.from(json['uses'] ?? []),
      advantages: List<String>.from(json['advantages'] ?? []),
      disadvantages: List<String>.from(json['disadvantages'] ?? []),
      videoUrl: json['video_url'],
      photoUrls: List<String>.from(json['photo_urls'] ?? []),
      isPopular: json['is_popular'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'strength': strength,
      'steps': steps.map((step) => step.toJson()).toList(),
      'uses': uses,
      'advantages': advantages,
      'disadvantages': disadvantages,
      'video_url': videoUrl,
      'photo_urls': photoUrls,
      'is_popular': isPopular,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class KnotStep {
  final int stepNumber;
  final String description;
  final String? imageUrl;
  final String? tip;

  KnotStep({
    required this.stepNumber,
    required this.description,
    this.imageUrl,
    this.tip,
  });

  factory KnotStep.fromJson(Map<String, dynamic> json) {
    return KnotStep(
      stepNumber: json['step_number'],
      description: json['description'],
      imageUrl: json['image_url'],
      tip: json['tip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step_number': stepNumber,
      'description': description,
      'image_url': imageUrl,
      'tip': tip,
    };
  }
}