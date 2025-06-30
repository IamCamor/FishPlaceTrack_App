class Like {
  final String id;
  final String entryId;
  final String userId;
  final DateTime createdAt;

  Like({
    required this.id,
    required this.entryId,
    required this.userId,
    required this.createdAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      entryId: json['entryId'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entryId': entryId,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}