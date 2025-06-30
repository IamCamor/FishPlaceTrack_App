import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/entry_provider.dart';
import '../../widgets/fish_top_item.dart';

class TopFishScreen extends StatelessWidget {
  final String fishType;
  
  const TopFishScreen({super.key, required this.fishType});

  @override
  Widget build(BuildContext context) {
    final entries = Provider.of<EntryProvider>(context).entries;
    
    // Фильтруем записи по виду рыбы и сортируем по весу
    final fishEntries = entries
        .where((e) => e.fishType == fishType)
        .toList()
      ..sort((a, b) => b.weight.compareTo(a.weight));
    
    return Scaffold(
      appBar: AppBar(title: Text('Топ по $fishType')),
      body: ListView.builder(
        itemCount: fishEntries.length,
        itemBuilder: (context, index) {
          return FishTopItem(
            entry: fishEntries[index],
            rank: index + 1,
          );
        },
      ),
    );
  }
}