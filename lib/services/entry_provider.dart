import 'package:flutter/material.dart';
import '../models/fishing_entry.dart';
import '../services/api_service.dart';

class EntryProvider with ChangeNotifier {
  List<FishingEntry> _entries = [];
  late Future<List<FishingEntry>> _entriesFuture;

  List<FishingEntry> get entries => _entries;
  Future<List<FishingEntry>> get entriesFuture => _entriesFuture;

  EntryProvider() {
    refreshEntries();
  }

  Future<void> refreshEntries() async {
    _entriesFuture = ApiService.getEntries();
    _entries = await _entriesFuture;
    notifyListeners();
  }

  void addEntry(FishingEntry entry) {
    _entries.insert(0, entry);
    notifyListeners();
  }

  void updateEntry(FishingEntry updatedEntry) {
    final index = _entries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      _entries[index] = updatedEntry;
      notifyListeners();
    }
  }

  void deleteEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  List<FishingEntry> getEntriesByUserId(String userId) {
    return _entries.where((e) => e.userId == userId).toList();
  }
}