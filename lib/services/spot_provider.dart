import 'package:flutter/material.dart';
import '../models/fishing_spot.dart';
import '../services/api_service.dart';

class SpotProvider with ChangeNotifier {
  List<FishingSpot> _spots = [];
  List<FishingSpot> get spots => _spots;

  Future<void> loadSpots() async {
    _spots = await ApiService.getFishingSpots();
    notifyListeners();
  }

  void addSpot(FishingSpot spot) {
    _spots.add(spot);
    notifyListeners();
  }

  void updateSpot(FishingSpot updatedSpot) {
    final index = _spots.indexWhere((s) => s.id == updatedSpot.id);
    if (index != -1) {
      _spots[index] = updatedSpot;
      notifyListeners();
    }
  }

  void deleteSpot(String id) {
    _spots.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}