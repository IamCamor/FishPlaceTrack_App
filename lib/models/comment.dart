
class Comment {
  final String id;
  final String entryId;
  final String userId;
  final String text;
  final DateTime createdAt;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.entryId,
    required this.userId,
    required this.text,
    required this.createdAt,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      entryId: json['entryId'],
      userId: json['userId'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      replies: (json['replies'] as List)
          .map((replyJson) => Comment.fromJson(replyJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entryId': entryId,
      'userId': userId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }
}