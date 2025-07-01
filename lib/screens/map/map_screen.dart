import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme/app_theme.dart';
import '../../models/location.dart';
import '../../services/api_service.dart';
import '../../widgets/location_bottom_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final List<Location> _locations = [];
  LocationType? _selectedLocationType;
  bool _isLoading = true;

  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(55.7558, 37.6176), // Moscow
    zoom: 10,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadLocations();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationPermissionDialog();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationPermissionDialog();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      }

      // Load locations around current position
      _loadNearbyLocations(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _loadLocations() async {
    try {
      final locations = await ApiService().getLocations(limit: 100);
      _updateMapMarkers(locations);
      setState(() {
        _locations.clear();
        _locations.addAll(locations);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Ошибка загрузки мест');
    }
  }

  Future<void> _loadNearbyLocations(double lat, double lng) async {
    try {
      final locations = await ApiService().getLocations(
        lat: lat,
        lng: lng,
        radius: 50.0, // 50km radius
        type: _selectedLocationType,
      );
      _updateMapMarkers(locations);
      setState(() {
        _locations.clear();
        _locations.addAll(locations);
      });
    } catch (e) {
      _showError('Ошибка загрузки близких мест');
    }
  }

  void _updateMapMarkers(List<Location> locations) {
    final markers = <Marker>{};

    // Add current location marker
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Моё местоположение'),
        ),
      );
    }

    // Add location markers
    for (final location in locations) {
      markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: LatLng(location.latitude, location.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerColor(location.type),
          ),
          infoWindow: InfoWindow(
            title: location.name,
            snippet: location.type.displayName,
          ),
          onTap: () => _showLocationDetails(location),
        ),
      );
    }

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  double _getMarkerColor(LocationType type) {
    switch (type) {
      case LocationType.fishingSpot:
        return BitmapDescriptor.hueGreen;
      case LocationType.shop:
        return BitmapDescriptor.hueOrange;
      case LocationType.base:
        return BitmapDescriptor.hueBlue;
      case LocationType.slip:
        return BitmapDescriptor.hueViolet;
      case LocationType.farm:
        return BitmapDescriptor.hueRose;
      case LocationType.pier:
        return BitmapDescriptor.hueYellow;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  void _showLocationDetails(Location location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationBottomSheet(location: location),
    );
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Службы геолокации отключены'),
        content: const Text('Включите службы геолокации для отображения вашего местоположения.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Разрешение на геолокацию'),
        content: const Text('Предоставьте разрешение на использование геолокации для отображения вашего местоположения.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
            child: const Text('Настройки'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта мест'),
        actions: [
          PopupMenuButton<LocationType?>(
            icon: Icon(
              _selectedLocationType != null 
                ? Icons.filter_alt 
                : Icons.filter_alt_outlined,
              color: _selectedLocationType != null 
                ? AppTheme.primary 
                : null,
            ),
            onSelected: (type) {
              setState(() {
                _selectedLocationType = type;
              });
              if (_currentPosition != null) {
                _loadNearbyLocations(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                );
              } else {
                _loadLocations();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: null,
                child: Row(
                  children: [
                    Icon(
                      Icons.clear,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    const Text('Все места'),
                  ],
                ),
              ),
              ...LocationType.values.map(
                (type) => PopupMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.getLocationTypeColor(type.name),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(type.displayName),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _defaultPosition,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
              if (_currentPosition != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                  ),
                );
              }
            },
            onCameraMove: (position) {
              // Optional: Load locations when map moves
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          Positioned(
            bottom: 24,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: 'my_location',
                  onPressed: _getCurrentLocation,
                  backgroundColor: AppTheme.surface,
                  foregroundColor: AppTheme.primary,
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'add_location',
                  onPressed: () {
                    // TODO: Navigate to add location
                  },
                  child: const Icon(Icons.add_location_alt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}