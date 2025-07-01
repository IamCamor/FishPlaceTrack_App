import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme/app_theme.dart';
import '../../models/location.dart';
import '../../services/api_service.dart';
import '../../widgets/location_bottom_sheet.dart';
import '../../utils/marker_icons.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin {
  YandexMapController? _mapController;
  Position? _currentPosition;
  final List<PlacemarkMapObject> _placemarks = [];
  final List<Location> _locations = [];
  LocationType? _selectedLocationType;
  bool _isLoading = true;

  static const Point _defaultPosition = Point(
    latitude: 55.7558, 
    longitude: 37.6176, // Moscow
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
        await _mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: Point(
                latitude: position.latitude, 
                longitude: position.longitude,
              ),
              zoom: 14,
            ),
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
      _updateMapPlacemarks(locations);
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
      _updateMapPlacemarks(locations);
      setState(() {
        _locations.clear();
        _locations.addAll(locations);
      });
    } catch (e) {
      _showError('Ошибка загрузки близких мест');
    }
  }

  Future<void> _updateMapPlacemarks(List<Location> locations) async {
    final placemarks = <PlacemarkMapObject>[];

    // Add current location placemark
    if (_currentPosition != null) {
      final currentLocationIcon = await MarkerIcons.getCurrentLocationIcon();
      placemarks.add(
        PlacemarkMapObject(
          mapId: const MapObjectId('current_location'),
          point: Point(
            latitude: _currentPosition!.latitude, 
            longitude: _currentPosition!.longitude,
          ),
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromBytes(currentLocationIcon),
            scale: 1.0,
          )),
          onTap: (placemark, point) {
            _showInfoDialog('Моё местоположение');
          },
        ),
      );
    }

    // Add location placemarks
    for (final location in locations) {
      final locationIcon = await _getMarkerIcon(location.type);
      placemarks.add(
        PlacemarkMapObject(
          mapId: MapObjectId(location.id),
          point: Point(latitude: location.latitude, longitude: location.longitude),
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromBytes(locationIcon),
            scale: 1.0,
          )),
          onTap: (placemark, point) => _showLocationDetails(location),
        ),
      );
    }

    setState(() {
      _placemarks.clear();
      _placemarks.addAll(placemarks);
    });
  }

  Future<Uint8List> _getMarkerIcon(LocationType type) async {
    switch (type) {
      case LocationType.fishingSpot:
        return await MarkerIcons.getFishingSpotIcon();
      case LocationType.shop:
        return await MarkerIcons.getShopIcon();
      case LocationType.base:
        return await MarkerIcons.getBaseIcon();
      case LocationType.slip:
        return await MarkerIcons.getSlipIcon();
      case LocationType.farm:
        return await MarkerIcons.getFarmIcon();
      case LocationType.pier:
        return await MarkerIcons.getPierIcon();
      default:
        return await MarkerIcons.getFishingSpotIcon();
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

  void _showInfoDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ОК'),
          ),
        ],
      ),
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
          YandexMap(
            onMapCreated: (controller) {
              _mapController = controller;
              controller.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _currentPosition != null
                        ? Point(
                            latitude: _currentPosition!.latitude,
                            longitude: _currentPosition!.longitude,
                          )
                        : _defaultPosition,
                    zoom: 10,
                  ),
                ),
              );
            },
            mapObjects: _placemarks,
            onMapTap: (point) {
              // Можно добавить обработку тапа по карте
            },
            onCameraPositionChanged: (cameraPosition, reason, finished) {
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