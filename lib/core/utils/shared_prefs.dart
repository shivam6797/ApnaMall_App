import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apnamall_ecommerce_app/features/address/data/model/address_model.dart';

class SharedPrefs {
  static const String _savedAddressesKey = "saved_addresses";
  static const String _selectedAddressKey = "selected_address";
  static const _userProfileKey = 'user_profile';

  /// Save a new address to the list
  static Future<void> saveAddress(AddressModel address) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> existingList = prefs.getStringList(_savedAddressesKey) ?? [];

    // Remove old entry with same ID (for update)
    existingList.removeWhere((element) {
      final decoded = jsonDecode(element);
      return decoded['id'] == address.id;
    });

    // Add updated/new entry
    existingList.add(jsonEncode(address.toJson()));
    await prefs.setStringList(_savedAddressesKey, existingList);
  }

  /// Get list of saved addresses
  static Future<List<AddressModel>> getSavedAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> saved = prefs.getStringList(_savedAddressesKey) ?? [];

    return saved.map((e) => AddressModel.fromJson(jsonDecode(e))).toList();
  }

  /// Set the currently selected address
  static Future<void> setSelectedAddress(AddressModel address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedAddressKey, jsonEncode(address.toJson()));
  }

  /// Get the selected address
  static Future<AddressModel?> getSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_selectedAddressKey);

    if (jsonStr == null) return null;

    return AddressModel.fromJson(jsonDecode(jsonStr));
  }

  /// Save the full address list (used when deleting/editing)
  static Future<void> saveAddressList(List<AddressModel> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = addresses.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_savedAddressesKey, encodedList);
  }

  /// Clear the selected address (used when deleted)
  static Future<void> clearSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedAddressKey);
  }

  static Future<void> setUserProfile(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileKey, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userProfileKey);
    if (data == null) return null;
    return jsonDecode(data);
  }
}
