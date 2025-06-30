
class Report {
  final String id;
  final String reporterId;
  final String targetId;
  final ReportType type;
  final String reason;
  final DateTime createdAt;
  ReportStatus status;

  Report({
    required this.id,
    required this.reporterId,
    required this.targetId,
    required this.type,
    required this.reason,
    required this.createdAt,
    this.status = ReportStatus.pending,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      reporterId: json['reporterId'],
      targetId: json['targetId'],
      type: ReportType.values.firstWhere(
        (e) => e.toString() == 'ReportType.${json['type']}'),
      reason: json['reason'],
      createdAt: DateTime.parse(json['createdAt']),
      status: ReportStatus.values.firstWhere(
        (e) => e.toString() == 'ReportStatus.${json['status']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporterId': reporterId,
      'targetId': targetId,
      'type': type.toString().split('.').last,
      'reason': reason,
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  String get targetType {
    switch (type) {
      case ReportType.user: return 'пользователя';
      case ReportType.entry: return 'запись';
      case ReportType.place: return 'место';
      case ReportType.comment: return 'комментарий';
      default: return '';
    }
  }
}

enum ReportType { user, entry, place, comment }
enum ReportStatus { pending, in_progress, resolved, rejected }