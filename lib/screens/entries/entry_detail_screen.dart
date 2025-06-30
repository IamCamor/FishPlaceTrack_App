import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/fishing_entry.dart';
import '../../services/entry_provider.dart';
import '../../widgets/social_actions.dart';
import '../../widgets/report_button.dart';

class EntryDetailScreen extends StatefulWidget {
  final String entryId;
  
  const EntryDetailScreen({super.key, required this.entryId});

  @override
  _EntryDetailScreenState createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  late Future<FishingEntry> _entryFuture;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  void _loadEntry() {
    final entryProvider = Provider.of<EntryProvider>(context, listen: false);
    setState(() {
      _entryFuture = entryProvider.getEntryById(widget.entryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали улова'),
        actions: [
          ReportButton(
            targetId: widget.entryId,
            type: 'entry',
          ),
        ],
      ),
      body: FutureBuilder<FishingEntry>(
        future: _entryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData) {
            return const Center(child: Text('Запись не найдена'));
          }
          
          final entry = snapshot.data!;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // ... (подробное отображение записи)
                
                // Социальные действия
                SocialActions(entry: entry),
                
                // Комментарии
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Комментарии', style: TextStyle(fontSize: 18)),
                ),
                // ... (список комментариев)
              ],
            ),
          );
        },
      ),
    );
  }
}