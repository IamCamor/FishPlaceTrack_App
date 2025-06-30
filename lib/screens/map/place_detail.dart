import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/fishing_spot.dart';
import '../../widgets/rating_bar.dart';

class PlaceDetailScreen extends StatelessWidget {
  final FishingSpot spot;

  const PlaceDetailScreen({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(spot.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото места
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(spot.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Название и рейтинг
            Row(
              children: [
                Expanded(
                  child: Text(
                    spot.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                RatingBar(rating: spot.rating),
              ],
            ),
            const SizedBox(height: 8),
            
            // Тип места
            Chip(label: Text(spot.type)),
            const SizedBox(height: 16),
            
            // Описание
            Text(
              spot.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            
            // Контактная информация
            if (spot.phone != null || spot.website != null || spot.telegram != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Контактная информация:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (spot.phone != null)
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(spot.phone!),
                      onTap: () => launch('tel:${spot.phone}'),
                    ),
                  if (spot.website != null)
                    ListTile(
                      leading: const Icon(Icons.link),
                      title: Text(spot.website!),
                      onTap: () => launch(spot.website!),
                    ),
                  if (spot.telegram != null)
                    ListTile(
                      leading: const Icon(Icons.send),
                      title: Text('Telegram: ${spot.telegram!}'),
                      onTap: () => launch('https://t.me/${spot.telegram}'),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            
            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.directions),
                    label: const Text('Маршрут'),
                    onPressed: () => _openDirections(spot.latitude, spot.longitude),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('В закладки'),
                    onPressed: () => _addToBookmarks(spot.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDirections(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _addToBookmarks(String spotId) {
    // Реализация добавления в закладки
  }
}