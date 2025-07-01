import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:provider/provider.dart';
import '../services/entry_provider.dart';
import '../models/fishing_entry.dart';
import '../utils/marker_icons.dart';
import '../screens/entries/add_entry_screen.dart';

class MapScreen extends StatefulWidget {
  final Point? initialLocation;
  final String title;
  
  const MapScreen({super.key, this.initialLocation, required this.title});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late YandexMapController _mapController;
  final List<PlacemarkMapObject> _placemarks = [];
  final Map<String, FishingEntry> _placemarkEntries = {};
  Point? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePlacemarks();
    });
  }

  Future<void> _updatePlacemarks() async {
    final entries = Provider.of<EntryProvider>(context, listen: false).entries;
    final newPlacemarks = await _buildPlacemarks(entries);
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
          _mapController.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _selectedLocation ?? const Point(latitude: 55.7558, longitude: 37.6173),
                zoom: 10,
              ),
            ),
          );
        },
        mapObjects: _placemarks,
        onMapTap: (point) => _showLocationDetails(context, point),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Future<List<PlacemarkMapObject>> _buildPlacemarks(List<FishingEntry> entries) async {
    final placemarks = <PlacemarkMapObject>[];
    _placemarkEntries.clear();
    
    for (final entry in entries) {
      final placemarkId = entry.id!;
      final position = Point(latitude: entry.latitude, longitude: entry.longitude);
      final entryIcon = await MarkerIcons.getFishIcon(entry.fishType);
      
      final placemark = PlacemarkMapObject(
        mapId: MapObjectId(placemarkId),
        point: position,
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
          image: BitmapDescriptor.fromBytes(entryIcon),
          scale: _getMarkerScale(entry.fishType),
        )),
        onTap: (placemark, point) => _showEntryDetails(entry),
      );
      
      placemarks.add(placemark);
      _placemarkEntries[placemarkId] = entry;
    }
    return placemarks;
  }

  double _getMarkerScale(String fishType) {
    // Возвращаем разный размер маркера в зависимости от типа рыбы
    switch (fishType.toLowerCase()) {
      case 'щука': return 1.2;
      case 'судак': return 1.1;
      case 'окунь': return 1.0;
      case 'карп': return 1.3;
      default: return 1.0;
    }
  }

  void _showEntryDetails(FishingEntry entry) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
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
                onPressed: () => Navigator.pop(context),
                child: const Text('Закрыть'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLocationDetails(BuildContext context, Point position) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Координаты: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addEntryAtLocation(context, position),
                child: const Text('Добавить запись здесь'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addEntryAtLocation(BuildContext context, Point position) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEntryScreen(initialLocation: position),
      ),
    );
  }

  void _goToCurrentLocation() {
    // В реальном приложении нужно использовать геолокацию
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