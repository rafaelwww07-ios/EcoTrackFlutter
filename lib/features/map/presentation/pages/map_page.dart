import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/utils/extensions.dart';
import '../../data/models/recycling_point_model.dart';
import '../widgets/recycling_point_info.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';

/// Map page with recycling points using OpenStreetMap (free)
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  final List<Marker> _markers = [];
  RecyclingPointModel? _selectedPoint;
  final List<WasteType> _selectedFilters = [];

  // Mock recycling points data
  final List<RecyclingPointModel> _recyclingPoints = [
    RecyclingPointModel(
      id: '1',
      name: 'Green Recycling Center',
      address: '123 Main St, City',
      latitude: 37.7749,
      longitude: -122.4194,
      acceptedTypes: [WasteType.plastic, WasteType.glass, WasteType.paper],
      phone: '+1 234-567-8900',
      hours: 'Mon-Fri: 9AM-5PM',
    ),
    RecyclingPointModel(
      id: '2',
      name: 'Eco Electronics Hub',
      address: '456 Oak Ave, City',
      latitude: 37.7849,
      longitude: -122.4094,
      acceptedTypes: [WasteType.electronics, WasteType.batteries],
      phone: '+1 234-567-8901',
      hours: 'Mon-Sat: 10AM-6PM',
    ),
    RecyclingPointModel(
      id: '3',
      name: 'Community Recycling Point',
      address: '789 Pine Rd, City',
      latitude: 37.7649,
      longitude: -122.4294,
      acceptedTypes: [
        WasteType.plastic,
        WasteType.glass,
        WasteType.metal,
        WasteType.organic
      ],
      phone: '+1 234-567-8902',
      hours: '24/7',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    // Don't load points here - wait for context to be ready
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load points after context is ready
    if (_markers.isEmpty) {
      _loadRecyclingPoints();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          context.showErrorSnackBar('Location services are disabled');
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            context.showErrorSnackBar('Location permissions are denied');
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          context.showErrorSnackBar(
            'Location permissions are permanently denied',
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });

      _mapController.move(
        LatLng(position.latitude, position.longitude),
        AppConstants.defaultMapZoom,
      );
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Error getting location: $e');
      }
    }
  }

  void _loadRecyclingPoints() {
    if (!mounted) return;
    
    final filteredPoints = _selectedFilters.isEmpty
        ? _recyclingPoints
        : _recyclingPoints.where((point) {
            return point.acceptedTypes.any(
              (type) => _selectedFilters.contains(type),
            );
          }).toList();

    // Get primary color from theme before setState
    final primaryColor = Theme.of(context).colorScheme.primary;

    setState(() {
      _markers.clear();
      for (final point in filteredPoints) {
        _markers.add(
          Marker(
            point: LatLng(point.latitude, point.longitude),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() {
                    _selectedPoint = point;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  void _toggleFilter(WasteType type) {
    setState(() {
      if (_selectedFilters.contains(type)) {
        _selectedFilters.remove(type);
      } else {
        _selectedFilters.add(type);
      }
      _loadRecyclingPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialCenter = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : const LatLng(37.7749, -122.4194); // Default to San Francisco

    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recyclingPoints),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'My Location',
          ),
        ],
      ),
      body: Stack(
        children: [
          // OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: AppConstants.defaultMapZoom,
              minZoom: AppConstants.minMapZoom,
              maxZoom: AppConstants.maxMapZoom,
              onTap: (tapPosition, point) {
                // Close selected point info when tapping on map
                if (mounted && _selectedPoint != null) {
                  setState(() {
                    _selectedPoint = null;
                  });
                }
              },
            ),
            children: [
              // OpenStreetMap tiles (free)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.eco_track_flutter',
                maxZoom: 19,
                errorTileCallback: (tile, error, stackTrace) {
                  // Handle tile loading errors gracefully
                  debugPrint('Tile loading error: $error');
                },
              ),
              // Markers
              MarkerLayer(markers: _markers),
              // Current location marker
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      width: 30,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          // Filters
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.filterByType,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: WasteType.values.map((type) {
                        final isSelected = _selectedFilters.contains(type);
                        return FilterChip(
                          label: Text(type.displayName),
                          selected: isSelected,
                          onSelected: (_) => _toggleFilter(type),
                          avatar: Text(type.iconName),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Selected point info
          if (_selectedPoint != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: RecyclingPointInfo(
                point: _selectedPoint!,
                onClose: () {
                  if (mounted) {
                    setState(() {
                      _selectedPoint = null;
                    });
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
