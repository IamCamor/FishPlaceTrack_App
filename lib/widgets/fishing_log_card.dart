import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/fishing_log.dart';
import '../theme/app_theme.dart';

class FishingLogCard extends StatelessWidget {
  final FishingLog fishingLog;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final bool isLiked;

  const FishingLogCard({
    super.key,
    required this.fishingLog,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fishingLog.title ?? 'Рыбалка',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          timeago.format(fishingLog.date, locale: 'ru'),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_horiz,
                      color: AppTheme.textSecondary,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'share':
                          onShare?.call();
                          break;
                        case 'edit':
                          // TODO: Navigate to edit
                          break;
                        case 'delete':
                          // TODO: Show delete dialog
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share),
                            SizedBox(width: 8),
                            Text('Поделиться'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Редактировать'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Удалить', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Location info
            if (fishingLog.location.name.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.place,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        fishingLog.location.name,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Photos
            if (fishingLog.photoUrls.isNotEmpty)
              Container(
                height: 200,
                margin: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: fishingLog.photoUrls.length == 1
                    ? _buildSinglePhoto(fishingLog.photoUrls.first)
                    : _buildPhotoGrid(fishingLog.photoUrls),
                ),
              ),

            // Catches summary
            if (fishingLog.catches.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: fishingLog.catches.take(3).map((catch) {
                    return Chip(
                      label: Text(
                        '${catch.fishTypeName} ${catch.weight.toStringAsFixed(1)}кг',
                        style: const TextStyle(fontSize: 12),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ),

            // Description
            if (fishingLog.description != null && fishingLog.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  fishingLog.description!,
                  style: context.textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatChip(
                    Icons.fishing,
                    '${fishingLog.totalCount}',
                    'рыб',
                  ),
                  const SizedBox(width: 8),
                  _buildStatChip(
                    Icons.scale,
                    '${fishingLog.totalWeight.toStringAsFixed(1)}кг',
                    'общий вес',
                  ),
                  if (fishingLog.weather != null) ...[
                    const SizedBox(width: 8),
                    _buildStatChip(
                      Icons.thermostat,
                      '${fishingLog.weather!.temperature.toStringAsFixed(0)}°',
                      '',
                    ),
                  ],
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: onLike,
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '${fishingLog.likesCount}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: onComment,
                        icon: Icon(
                          Icons.comment_outlined,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        '${fishingLog.commentsCount}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: onShare,
                    icon: Icon(
                      Icons.share_outlined,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSinglePhoto(String photoUrl) {
    return CachedNetworkImage(
      imageUrl: photoUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (context, url) => Container(
        color: AppTheme.background,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppTheme.background,
        child: const Center(
          child: Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(List<String> photoUrls) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: photoUrls.length > 2 ? 2 : photoUrls.length,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: photoUrls.length > 4 ? 4 : photoUrls.length,
      itemBuilder: (context, index) {
        final isLast = index == 3 && photoUrls.length > 4;
        return Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: photoUrls[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppTheme.background,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppTheme.background,
                child: const Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
            if (isLast)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Text(
                    '+${photoUrls.length - 4}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}