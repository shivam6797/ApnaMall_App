import 'dart:async';
import 'package:apnamall_ecommerce_app/core/utils/location_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationPicker extends StatefulWidget {
  final Function(String address, LatLng latLng) onLocationSelected;

  const LocationPicker({super.key, required this.onLocationSelected});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng? _pickedLocation;
  String _address = "Fetching address...";

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  Future<void> _setInitialLocation() async {
    Position? position = await LocationService.getCurrentLocation();
    if (position != null) {
      _pickedLocation = LatLng(position.latitude, position.longitude);
      _updateAddress(_pickedLocation!);

      final controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(_pickedLocation!, 15),
      );
      setState(() {});
    }
  }

  Future<void> _updateAddress(LatLng position) async {
    final address = await LocationService.getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );
    if (address != null) {
      setState(() {
        _address = address;
      });
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _pickedLocation = position;
      _address = "Fetching address...";
    });
    _updateAddress(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Location')),
      body: (_pickedLocation == null)
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _pickedLocation!,
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onTap: _onMapTap,
                    markers: _pickedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId('selected'),
                              position: _pickedLocation!,
                            ),
                          }
                        : {},
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _address,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (_pickedLocation != null) {
                                widget.onLocationSelected(
                                  _address,
                                  _pickedLocation!,
                                );
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.check_circle),
                            label: const Text("Use this location"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
