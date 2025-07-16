class AddressModel {
  final String id; // 🔥 Unique ID for delete/edit
  final String name;
  final String phone;
  final String street;
  final String landmark;
  final String city;
  final String state;
  final String pinCode;
  final String fullAddress;
  final double latitude;
  final double longitude;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.street,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '', // ✅ make sure id is stored
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      street: json['street'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pinCode: json['pinCode'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'street': street,
    'landmark': landmark,
    'city': city,
    'state': state,
    'pinCode': pinCode,
    'fullAddress': fullAddress,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory AddressModel.empty() => AddressModel(
    id: '',
    name: '',
    phone: '',
    landmark: '',
    street: '',
    city: '',
    state: '',
    pinCode: '',
    fullAddress: '',
    latitude: 0.0,
    longitude: 0.0,
  );
  @override
  String toString() {
    return 'AddressModel{id: $id, name: $name, phone: $phone, street: $street, landmark: $landmark, city: $city, state: $state, pinCode: $pinCode, fullAddress: $fullAddress, latitude: $latitude, longitude: $longitude}';
  }
}
