import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/top_fisher_card.dart';

class TopFishersScreen extends StatefulWidget {
  final String? period;
  
  const TopFishersScreen({super.key, this.period});

  @override
  _TopFishersScreenState createState() => _TopFishersScreenState();
}

class _TopFishersScreenState extends State<TopFishersScreen> {
  late Future<List<User>> _topFishersFuture;

  @override
  void initState() {
    super.initState();
    _loadTopFishers();
  }

  void _loadTopFishers() {
    setState(() {
      _topFishersFuture = ApiService.getTopFishers(widget.period);
    });
  }

  String get _title {
    switch (widget.period) {
      case 'month': return 'Лучшие рыболовы месяца';
      case 'week': return 'Лучшие рыболовы недели';
      default: return 'Лучшие рыболовы';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: FutureBuilder<List<User>>(
        future: _topFishersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          
          final fishers = snapshot.data!;
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: fishers.length,
            itemBuilder: (context, index) {
              return TopFisherCard(
                fisher: fishers[index],
                position: index + 1,
              );
            },
          );
        },
      ),
    );
  }
}