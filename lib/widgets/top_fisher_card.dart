import 'package:flutter/material.dart';
import '../models/user.dart';

class TopFisherCard extends StatelessWidget {
  final User fisher;
  final int position;
  final String fishType;

  const TopFisherCard({super.key, 
    required this.fisher,
    required this.position,
    required this.fishType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: fisher.avatarUrl != null
                  ? NetworkImage(fisher.avatarUrl!)
                  : null,
              child: fisher.avatarUrl == null
                  ? Icon(Icons.person, size: 24)
                  : null,
            ),
            if (position <= 3)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _getMedalColor(position),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    position.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(fisher.name),
        subtitle: Text('Лучший улов: $fishType'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${fisher.totalWeight} кг',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${fisher.totalCatches} уловов',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMedalColor(int position) {
    switch (position) {
      case 1: return Colors.amber;
      case 2: return Colors.grey;
      case 3: return Colors.brown;
      default: return Colors.blue;
    }
  }
}