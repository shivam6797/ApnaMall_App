import 'dart:async';
import 'package:apnamall_ecommerce_app/core/utils/shared_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:apnamall_ecommerce_app/core/utils/validators.dart';
import 'package:apnamall_ecommerce_app/core/utils/location_services.dart';
import 'package:apnamall_ecommerce_app/features/address/data/model/address_model.dart';
import 'package:apnamall_ecommerce_app/config/app_routes.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  AddressModel? editingAddress;
  bool isUsingCurrentLocation = false;
  bool isLoadingLocation = false;
  String currentAddress = "";
  LatLng? _pickedLatLng;
  final Completer<GoogleMapController> _mapController = Completer();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _houseController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  String? _nameError;
  String? _phoneError;
  String? _houseError;
  String? _pincodeError;
  String? _cityError;
  String? _stateError;

  double? latitude;
  double? longitude;

  Future<void> _useCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
      isUsingCurrentLocation = true;
    });

    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      final address = await LocationService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _pickedLatLng = LatLng(position.latitude, position.longitude);
        currentAddress = address ?? "Could not fetch address.";
        latitude = position.latitude;
        longitude = position.longitude;
        isLoadingLocation = false;
      });
    } else {
      setState(() {
        isLoadingLocation = false;
        currentAddress = "Location not available.";
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is AddressModel) {
      // Editing
      _nameController.text = args.name;
      _phoneController.text = args.phone;
      _houseController.text = args.street;
      _landmarkController.text = args.landmark;
      _cityController.text = args.city;
      _stateController.text = args.state;
      _pincodeController.text = args.pinCode;
      latitude = args.latitude;
      longitude = args.longitude;
    } else {
      // New entry, load from user profile
      SharedPrefs.getUserProfile().then((user) {
        if (user != null) {
          _nameController.text = user['name'] ?? '';
          _phoneController.text = user['mobile_number'] ?? '';
        }
      });
    }
  }

  void _submit() async {
    setState(() {
      _nameError = Validators.validateName(
        _nameController.text,
        fieldName: "Name",
      );
      _phoneError = Validators.validatePhone(_phoneController.text);
      _houseError = Validators.validateName(
        _houseController.text,
        fieldName: "House / Flat No.",
      );
      _pincodeError = _pincodeController.text.isEmpty
          ? "Pincode is required"
          : null;
      _cityError = Validators.validateName(
        _cityController.text,
        fieldName: "City",
      );
      _stateError = Validators.validateName(
        _stateController.text,
        fieldName: "State",
      );
    });

    if (_nameError == null &&
        _phoneError == null &&
        _houseError == null &&
        _pincodeError == null &&
        _cityError == null &&
        _stateError == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final isEditing = args != null && args is AddressModel;

      final addressModel = AddressModel(
        id: isEditing
            ? args.id
            : DateTime.now().millisecondsSinceEpoch
                  .toString(), // ✅ yahi change hai
        name: _nameController.text,
        phone: _phoneController.text,
        landmark: _landmarkController.text,
        street: _houseController.text,
        city: _cityController.text,
        state: _stateController.text,
        pinCode: _pincodeController.text,
        fullAddress:
            "${_houseController.text}, ${_landmarkController.text}, ${_cityController.text}, ${_stateController.text}, ${_pincodeController.text}",
        latitude: double.tryParse(latitude.toString()) ?? 0.0,
        longitude: double.tryParse(longitude.toString()) ?? 0.0,
      );

      await SharedPrefs.saveAddress(addressModel);
      await SharedPrefs.setSelectedAddress(addressModel);
      Navigator.pushReplacementNamed(context, AppRoutes.routeSavedAddress);
    }
  }

  Future<void> _updateLocation(LatLng newLatLng) async {
    setState(() {
      isLoadingLocation = true;
    });

    final address = await LocationService.getAddressFromLatLng(
      newLatLng.latitude,
      newLatLng.longitude,
    );

    setState(() {
      _pickedLatLng = newLatLng;
      latitude = newLatLng.latitude;
      longitude = newLatLng.longitude;
      currentAddress = address ?? "Address not found.";
      isLoadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Add Address",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Poppins",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Address Option:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _useCurrentLocation,
                    child: SizedBox(
                      height: 110,
                      child: Card(
                        color: isUsingCurrentLocation
                            ? Colors.green.shade100
                            : Colors.white,
                        elevation: isUsingCurrentLocation ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isUsingCurrentLocation
                                ? Colors.green
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.my_location, size: 30),
                              SizedBox(height: 8),
                              Text("Use Current Location"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isUsingCurrentLocation = false;
                      });
                    },
                    child: SizedBox(
                      height: 110,
                      child: Card(
                        color: !isUsingCurrentLocation
                            ? Colors.green.shade100
                            : Colors.white,
                        elevation: !isUsingCurrentLocation ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: !isUsingCurrentLocation
                                ? Colors.green
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_location_alt, size: 30),
                              SizedBox(height: 8),
                              Text("Enter Manually"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (isUsingCurrentLocation)
              isLoadingLocation
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Card(
                          color: Colors.grey[100],
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(width: 10),
                                Expanded(child: Text(currentAddress)),
                              ],
                            ),
                          ),
                        ),
                        if (_pickedLatLng != null)
                          SizedBox(
                            height: 350,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: _pickedLatLng!,
                                  zoom: 16,
                                ),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId(
                                      "selected-location",
                                    ),
                                    position: _pickedLatLng!,
                                    draggable: true,
                                    onDragEnd: (LatLng newPosition) {
                                      _updateLocation(newPosition);
                                    },
                                  ),
                                },
                                onMapCreated: (controller) {
                                  if (!_mapController.isCompleted) {
                                    _mapController.complete(controller);
                                  }
                                },
                                onTap: (LatLng newLatLng) {
                                  _updateLocation(newLatLng);
                                },
                                myLocationEnabled: true,
                                zoomControlsEnabled: true,
                                gestureRecognizers: {
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final existingAddresses =
                                await SharedPrefs.getSavedAddresses();
                            // Check if address already exists (based on fullAddress or lat/lng)
                            final alreadyExists = existingAddresses.any(
                              (address) =>
                                  address.fullAddress == currentAddress ||
                                  (address.latitude == latitude &&
                                      address.longitude == longitude),
                            );
                            AddressModel addressModel;
                            if (alreadyExists) {
                              // Address already saved, find and select that one
                              addressModel = existingAddresses.firstWhere(
                                (address) =>
                                    address.fullAddress == currentAddress ||
                                    (address.latitude == latitude &&
                                        address.longitude == longitude),
                              );
                            } else {
                              // New address, save and select
                              addressModel = AddressModel(
                                id: DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                name: "",
                                phone: "",
                                landmark: "",
                                street: "",
                                city: "",
                                state: "",
                                pinCode: "",
                                fullAddress: currentAddress,
                                latitude: latitude ?? 0.0,
                                longitude: longitude ?? 0.0,
                              );
                              await SharedPrefs.saveAddress(addressModel);
                            }
                            // In both cases, select this address
                            await SharedPrefs.setSelectedAddress(addressModel);
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.routeSavedAddress,
                            );
                          },
                          icon: const Icon(Icons.check),
                          label: const Text("Confirm & Use This Location"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),

            if (!isUsingCurrentLocation) ...[
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                onChanged: (val) => setState(() {
                  _nameError = Validators.validateName(val, fieldName: "Name");
                }),
                decoration: InputDecoration(
                  labelText: "Name",
                  errorText: _nameError,
                ),
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (val) => setState(() {
                  _phoneError = Validators.validatePhone(val);
                }),
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  errorText: _phoneError,
                ),
              ),
              TextField(
                controller: _houseController,
                onChanged: (val) => setState(() {
                  _houseError = Validators.validateName(
                    val,
                    fieldName: "House / Flat No.",
                  );
                }),
                decoration: InputDecoration(
                  labelText: "House / Flat No.",
                  errorText: _houseError,
                ),
              ),
              TextField(
                controller: _landmarkController,
                decoration: const InputDecoration(
                  labelText: "Landmark (optional)",
                ),
              ),
              TextField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                onChanged: (val) => setState(() {
                  _pincodeError = val.isEmpty ? "Pincode is required" : null;
                }),
                decoration: InputDecoration(
                  labelText: "Pincode",
                  errorText: _pincodeError,
                ),
              ),
              TextField(
                controller: _cityController,
                onChanged: (val) => setState(() {
                  _cityError = Validators.validateName(val, fieldName: "City");
                }),
                decoration: InputDecoration(
                  labelText: "City",
                  errorText: _cityError,
                ),
              ),
              TextField(
                controller: _stateController,
                onChanged: (val) => setState(() {
                  _stateError = Validators.validateName(
                    val,
                    fieldName: "State",
                  );
                }),
                decoration: InputDecoration(
                  labelText: "State",
                  errorText: _stateError,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text("Save Address"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
