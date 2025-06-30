import 'package:flutter/material.dart';
import '../models/achievement.dart';

class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  
  const AchievementBadge({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: achievement.description,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: achievement.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: achievement.color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(achievement.icon, size: 32, color: achievement.color),
            const SizedBox(height: 8),
            Text(
              achievement.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: achievement.color,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}