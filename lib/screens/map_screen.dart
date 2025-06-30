import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../services/entry_provider.dart';
import '../models/fishing_entry.dart';

class MapScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final String title;
  
  const MapScreen({super.key, this.initialLocation, required this.title});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Map<MarkerId, FishingEntry> _markerEntries = {};
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    final entries = Provider.of<EntryProvider>(context).entries;
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedLocation ?? const LatLng(55.7558, 37.6173),
          zoom: 10,
        ),
        markers: _buildMarkers(entries),
        onMapCreated: (controller) => _mapController = controller,
        onTap: (latLng) => _showLocationDetails(context, latLng),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Set<Marker> _buildMarkers(List<FishingEntry> entries) {
    _markers.clear();
    _markerEntries.clear();
    
    for (final entry in entries) {
      final markerId = MarkerId(entry.id!);
      final position = LatLng(entry.latitude, entry.longitude);
      
      _markers.add(
        Marker(
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(title: entry.location),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerHue(entry.fishType),
          ),
        ),
      );
      _markerEntries[markerId] = entry;
    }
    return _markers;
  }

  double _getMarkerHue(String fishType) {
    switch (fishType.toLowerCase()) {
      case 'щука': return BitmapDescriptor.hueGreen;
      case 'судак': return BitmapDescriptor.hueBlue;
      case 'окунь': return BitmapDescriptor.hueOrange;
      case 'карп': return BitmapDescriptor.hueYellow;
      default: return BitmapDescriptor.hueRed;
    }
  }

  void _showLocationDetails(BuildContext context, LatLng position) {
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

  void _addEntryAtLocation(BuildContext context, LatLng position) {
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