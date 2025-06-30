import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/entry_provider.dart';
import '../../services/spot_provider.dart';
import '../../models/fishing_entry.dart';
import '../../models/fishing_spot.dart';
import './place_detail.dart';

class FishingMapScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final String title;
  
  const FishingMapScreen({
    super.key, 
    this.initialLocation, 
    required this.title
  });

  @override
  _FishingMapScreenState createState() => _FishingMapScreenState();
}

class _FishingMapScreenState extends State<FishingMapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Map<MarkerId, dynamic> _markerData = {};

  @override
  Widget build(BuildContext context) {
    final entries = Provider.of<EntryProvider>(context).entries;
    final spots = Provider.of<SpotProvider>(context).spots;
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.initialLocation ?? const LatLng(55.7558, 37.6173),
          zoom: 10,
        ),
        markers: _buildMarkers(entries, spots),
        onMapCreated: (controller) => _mapController = controller,
        onTap: (latLng) => _handleMapTap(latLng),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Set<Marker> _buildMarkers(List<FishingEntry> entries, List<FishingSpot> spots) {
    _markers.clear();
    _markerData.clear();
    
    // Маркеры для записей о рыбалке
    for (final entry in entries) {
      final markerId = MarkerId('entry_${entry.id}');
      final position = LatLng(entry.latitude, entry.longitude);
      
      _markers.add(
        Marker(
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(title: entry.location),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getEntryMarkerHue(entry.fishType),
          ),
          onTap: () => _showEntryDetails(entry),
        ),
      );
      _markerData[markerId] = entry;
    }
    
    // Маркеры для рыболовных мест
    for (final spot in spots) {
      final markerId = MarkerId('spot_${spot.id}');
      final position = LatLng(spot.latitude, spot.longitude);
      
      _markers.add(
        Marker(
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(title: spot.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onTap: () => _showSpotDetails(spot),
        ),
      );
      _markerData[markerId] = spot;
    }
    
    return _markers;
  }

  double _getEntryMarkerHue(String fishType) {
    switch (fishType.toLowerCase()) {
      case 'щука': return BitmapDescriptor.hueGreen;
      case 'судак': return BitmapDescriptor.hueBlue;
      case 'окунь': return BitmapDescriptor.hueOrange;
      case 'карп': return BitmapDescriptor.hueYellow;
      default: return BitmapDescriptor.hueRed;
    }
  }

  void _showEntryDetails(FishingEntry entry) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                entry.location,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Рыба: ${entry.fishType}'),
              Text('Вес: ${entry.weight} кг'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _openEntryDetails(entry),
                child: const Text('Подробнее'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSpotDetails(FishingSpot spot) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                spot.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Тип: ${spot.type}'),
              Text('Рейтинг: ${spot.rating}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _openSpotDetails(spot),
                child: const Text('Подробнее'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openEntryDetails(FishingEntry entry) {
    Navigator.pop(context);
    // Реализация экрана деталей записи
  }

  void _openSpotDetails(FishingSpot spot) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceDetailScreen(spot: spot),
      ),
    );
  }

  void _handleMapTap(LatLng position) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Новая точка',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Координаты: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _addNewEntry(position),
                      child: const Text('Добавить улов'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _addNewSpot(position),
                      child: const Text('Добавить место'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _addNewEntry(LatLng position) {
    Navigator.pop(context);
    // Открываем экран добавления улова с предустановленными координатами
  }

  void _addNewSpot(LatLng position) {
    Navigator.pop(context);
    // Открываем экран добавления места с предустановленными координатами
  }

  void _goToCurrentLocation() {
    // В реальном приложении используем геолокацию
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: const LatLng(55.7558, 37.6173),
          zoom: 14,
        ),
      ),
    );
  }
}