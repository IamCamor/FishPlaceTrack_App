import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/fishing_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/social_actions.dart';
import '../widgets/report_button.dart';

class EntryCard extends StatelessWidget {
  final FishingEntry entry;
  
  const EntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Заголовок
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: entry.userAvatar != null
                      ? CachedNetworkImageProvider(entry.userAvatar!)
                      : null,
                  child: entry.userAvatar == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd().format(entry.date),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                ReportButton(
                  targetId: entry.id!,
                  type: 'entry',
                ),
              ],
            ),
          ),
          
          // Фото улова
          if (entry.photoUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: entry.photoUrl!,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
          
          // Детали улова
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Chip(
                      avatar: const Icon(Icons.place, size: 16),
                      label: Text(entry.location),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      avatar: const Icon(Icons.fish, size: 16),
                      label: Text(entry.fishType),
                      backgroundColor: AppColors.fishTypeColors[entry.fishType]?.withOpacity(0.1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(
                      avatar: const Icon(Icons.scale, size: 16),
                      label: Text('${entry.weight} кг'),
                    ),
                    const SizedBox(width: 8),
                    if (entry.length != null)
                      Chip(
                        avatar: const Icon(Icons.straighten, size: 16),
                        label: Text('${entry.length} см'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  entry.notes,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                
                // Социальные действия
                SocialActions(entry: entry),
              ],
            ),
          ),
        ],
      ),
    );
  }
}