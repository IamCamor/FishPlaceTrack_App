import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReportButton extends StatelessWidget {
  final String targetId;
  final String type; // 'entry', 'user', 'place', 'comment'
  
  const ReportButton({super.key, required this.targetId, required this.type});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.report, color: Colors.orange),
      onPressed: () => _showReportDialog(context),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отправить жалобу'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Выберите причину:'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildReasonChip(context, 'Некорректный контент'),
                _buildReasonChip(context, 'Мошенничество'),
                _buildReasonChip(context, 'Оскорбительное поведение'),
                _buildReasonChip(context, 'Спам'),
                _buildReasonChip(context, 'Другое'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonChip(BuildContext context, String reason) {
    return ActionChip(
      label: Text(reason),
      onPressed: () {
        ApiService.submitReport(
          targetId: targetId,
          type: type,
          reason: reason,
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Жалоба отправлена'))
        );
      },
    );
  }
}