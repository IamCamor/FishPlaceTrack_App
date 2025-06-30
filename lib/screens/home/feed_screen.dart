import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/entry_provider.dart';
import '../../widgets/entry_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<EntryProvider>(context);

    return RefreshIndicator(
      onRefresh: () => entryProvider.refreshEntries(),
      child: FutureBuilder<List<FishingEntry>>(
        future: entryProvider.entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка загрузки данных'));
          }
          
          final entries = snapshot.data!;
          
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fishing, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Пока нет записей',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const Text(
                    'Добавьте свой первый улов!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) => EntryCard(entry: entries[index]),
          );
        },
      ),
    );
  }
}