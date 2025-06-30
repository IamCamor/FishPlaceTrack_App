import 'package:flutter/material.dart';
import '../models/fish_species.dart';
import '../services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FishGuideScreen extends StatefulWidget {
  const FishGuideScreen({super.key});

  @override
  _FishGuideScreenState createState() => _FishGuideScreenState();
}

class _FishGuideScreenState extends State<FishGuideScreen> {
  late Future<List<FishSpecies>> _fishSpeciesFuture;

  @override
  void initState() {
    super.initState();
    _loadFishSpecies();
  }

  void _loadFishSpecies() {
    setState(() {
      _fishSpeciesFuture = ApiService.getFishSpecies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Справочник рыб')),
      body: FutureBuilder<List<FishSpecies>>(
        future: _fishSpeciesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData) {
            return const Center(child: Text('Ошибка загрузки данных'));
          }
          
          final fishSpecies = snapshot.data!;
          
          return ListView.builder(
            itemCount: fishSpecies.length,
            itemBuilder: (context, index) {
              return _buildFishCard(fishSpecies[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildFishCard(FishSpecies fish) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CachedNetworkImage(
            imageUrl: fish.imageUrl,
            height: 200,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fish.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (fish.latinName != null)
                  Text(
                    fish.latinName!,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  fish.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Среда обитания:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(fish.habitat),
              ],
            ),
          ),
        ],
      ),
    );
  }
}