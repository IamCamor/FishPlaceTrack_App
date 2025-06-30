import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? color;
  
  const StatBadge({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color?.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color ?? AppColors.primary),
          ),
          child: Icon(icon, color: color ?? AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}