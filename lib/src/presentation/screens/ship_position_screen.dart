import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ShipPositionScreen extends StatefulWidget {
  const ShipPositionScreen({super.key});

  @override
  State<ShipPositionScreen> createState() => _ShipPositionScreenState();
}

class _ShipPositionScreenState extends State<ShipPositionScreen> {
  // Mock ship position - this would come from your real API
  final LatLng _shipPosition = const LatLng(37.7749, -122.4194);
  final MapController _mapController = MapController();

  // Simplified layers to avoid API errors
  bool _showSeaLayer = true;
  bool _showPortsLayer = true;

  double _zoom = 5.0;

  // Check if running on mobile
  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Text('Ship Position'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh ship position (mock for demo)
              _mapController.move(_shipPosition, _zoom);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Only show map if on mobile platform
          isMobile
              ? _buildMap()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 20),
                      Text(
                        'Map view available only on mobile devices',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                        label: Text('Go Back'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _shipPosition,
            initialZoom: _zoom,
            minZoom: 3,
            maxZoom: 18,
            backgroundColor: const Color(0xFF1A2639),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              tileProvider: CancellableNetworkTileProvider(),
              tileBuilder: (context, child, tile) {
                return Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF2C3E50), width: 0.5),
                  ),
                  child: child,
                );
              },
            ),
            // Ship marker
            MarkerLayer(
              markers: [
                Marker(
                  point: _shipPosition,
                  width: 48,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.9),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Иконка корабля
                        const Icon(
                          Icons.directions_boat,
                          color: Colors.white,
                          size: 24,
                        ),
                        // Индикатор внизу
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 16,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0D47A1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'UNISTAR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Add attribution to OpenStreetMap
        Positioned(
          bottom: 25,
          right: 5,
          child: Container(
            padding: const EdgeInsets.all(2),
            color: Colors.white.withOpacity(0.7),
            child: const Text(
              "© OpenStreetMap contributors",
              style: TextStyle(fontSize: 8, color: Colors.black),
            ),
          ),
        ),
        // Layer controls
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Map Layers',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: Colors.grey, height: 16),
                _buildLayerSwitch('Sea Routes', _showSeaLayer, (value) {
                  setState(() {
                    _showSeaLayer = value;
                  });
                }),
                _buildLayerSwitch('Ports', _showPortsLayer, (value) {
                  setState(() {
                    _showPortsLayer = value;
                  });
                }),
              ],
            ),
          ),
        ),
        // Ship info box
        Positioned(
          bottom: 60,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.cyan.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.directions_boat, color: Colors.cyan, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Unistar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey, height: 8),
                _buildInfoRow(
                    'Position', '37° 46\' 29.64" N, 122° 25\' 9.84" W'),
                _buildInfoRow('Speed', '14.5 knots'),
                _buildInfoRow('Heading', '275°'),
                _buildInfoRow('Last update', '2025-04-13 02:35 UTC'),
              ],
            ),
          ),
        ),
        // Zoom controls
        Positioned(
          left: 16,
          top: 16,
          child: Column(
            children: [
              _buildZoomButton(Icons.add, () {
                setState(() {
                  _zoom = (_zoom + 1).clamp(3.0, 18.0);
                  _mapController.move(_mapController.camera.center, _zoom);
                });
              }),
              const SizedBox(height: 8),
              _buildZoomButton(Icons.remove, () {
                setState(() {
                  _zoom = (_zoom - 1).clamp(3.0, 18.0);
                  _mapController.move(_mapController.camera.center, _zoom);
                });
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLayerSwitch(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.cyan,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onPressed) {
    return FloatingActionButton.small(
      backgroundColor: Colors.black.withOpacity(0.7),
      foregroundColor: Colors.white,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
