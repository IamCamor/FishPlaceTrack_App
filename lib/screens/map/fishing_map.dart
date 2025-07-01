import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:provider/provider.dart';
import '../../services/entry_provider.dart';
import '../../services/spot_provider.dart';
import '../../models/fishing_entry.dart';
import '../../models/fishing_spot.dart';
import '../../utils/marker_icons.dart';
import './place_detail.dart';

class FishingMapScreen extends StatefulWidget {
  final Point? initialLocation;
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
  late YandexMapController _mapController;
  final List<PlacemarkMapObject> _placemarks = [];
  final Map<String, dynamic> _placemarkData = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePlacemarks();
    });
  }

  Future<void> _updatePlacemarks() async {
    final entries = Provider.of<EntryProvider>(context, listen: false).entries;
    final spots = Provider.of<SpotProvider>(context, listen: false).spots;
    
    final newPlacemarks = await _buildPlacemarks(entries, spots);
    setState(() {
      _placemarks.clear();
      _placemarks.addAll(newPlacemarks);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: YandexMap(
        onMapCreated: (controller) {
          _mapController = controller;
          controller.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: widget.initialLocation ?? const Point(latitude: 55.7558, longitude: 37.6173),
                zoom: 10,
              ),
            ),
          );
        },
        mapObjects: _placemarks,
        onMapTap: (point) => _handleMapTap(point),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Future<List<PlacemarkMapObject>> _buildPlacemarks(List<FishingEntry> entries, List<FishingSpot> spots) async {
    _placemarks.clear();
    _placemarkData.clear();
    
    // Маркеры для записей о рыбалке
    for (final entry in entries) {
      final placemarkId = 'entry_${entry.id}';
      final position = Point(latitude: entry.latitude, longitude: entry.longitude);
      final entryIcon = await MarkerIcons.getFishIcon(entry.fishType);
      
      _placemarks.add(
        PlacemarkMapObject(
          mapId: MapObjectId(placemarkId),
          point: position,
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromBytes(entryIcon),
            scale: 1.0,
          )),
          onTap: (placemark, point) => _showEntryDetails(entry),
        ),
      );
      _placemarkData[placemarkId] = entry;
    }
    
    // Маркеры для рыболовных мест
    for (final spot in spots) {
      final placemarkId = 'spot_${spot.id}';
      final position = Point(latitude: spot.latitude, longitude: spot.longitude);
      final spotIcon = await MarkerIcons.getFishingSpotIcon();
      
      _placemarks.add(
        PlacemarkMapObject(
          mapId: MapObjectId(placemarkId),
          point: position,
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromBytes(spotIcon),
            scale: 1.1,
          )),
          onTap: (placemark, point) => _showSpotDetails(spot),
        ),
      );
      _placemarkData[placemarkId] = spot;
    }
    
    return _placemarks;
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

  void _handleMapTap(Point position) {
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

  void _addNewEntry(Point position) {
    Navigator.pop(context);
    // Открываем экран добавления улова с предустановленными координатами
  }

  void _addNewSpot(Point position) {
    Navigator.pop(context);
    // Открываем экран добавления места с предустановленными координатами
  }

  void _goToCurrentLocation() {
    // В реальном приложении используем геолокацию
    _mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: const Point(latitude: 55.7558, longitude: 37.6173),
          zoom: 14,
        ),
      ),
    );
  }
}