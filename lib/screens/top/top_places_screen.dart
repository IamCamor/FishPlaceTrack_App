import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/spot_provider.dart';
import '../models/fishing_spot.dart';
import '../widgets/spot_card.dart';

class TopPlacesScreen extends StatelessWidget {
  const TopPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spots = Provider.of<SpotProvider>(context).spots;
    
    // Сортируем места по рейтингу
    final sortedSpots = List.from(spots)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    
    return Scaffold(
      appBar: AppBar(title: const Text('Лучшие места для рыбалки')),
      body: ListView.builder(
        itemCount: sortedSpots.length,
        itemBuilder: (context, index) {
          return SpotCard(
            spot: sortedSpots[index],
            rank: index + 1,
          );
        },
      ),
    );
  }
}