import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:apnamall_ecommerce_app/core/utils/shared_prefs.dart';
import 'package:apnamall_ecommerce_app/features/address/data/model/address_model.dart';
import 'package:flutter/material.dart';

class SavedAddressScreen extends StatefulWidget {
  const SavedAddressScreen({super.key});

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  List<AddressModel> savedAddresses = [];
  AddressModel? selectedAddress;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  Future<void> _loadSavedAddresses() async {
    final addresses = await SharedPrefs.getSavedAddresses();
    final selected = await SharedPrefs.getSelectedAddress();
    setState(() {
      savedAddresses = addresses;
      selectedAddress = selected;
    });
  }

  void _onAddressSelected(AddressModel address) async {
    setState(() {
      selectedAddress = address;
    });
    await SharedPrefs.setSelectedAddress(address); // <-- correct method name
  }

  void _onProceed() {
    if (selectedAddress != null) {
      Navigator.pop(context); // Return to CartScreen instead of PaymentScreen
    }
  }

  Future<void> _deleteAddress(String id) async {
    savedAddresses.removeWhere((addr) => addr.id == id);
    await SharedPrefs.saveAddressList(savedAddresses);

    if (selectedAddress != null && selectedAddress!.id == id) {
      await SharedPrefs.clearSelectedAddress();
      selectedAddress = null;
    }

    setState(() {});
  }

  void _editAddress(AddressModel address) async {
    Navigator.pushNamed(
      context,
      AppRoutes.routeAddAddress,
      arguments: address,
    ).then((_) => _loadSavedAddresses());
  }

  bool _isSelected(AddressModel addr) {
    return addr.fullAddress == selectedAddress?.fullAddress &&
        addr.latitude == selectedAddress?.latitude &&
        addr.longitude == selectedAddress?.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Select Saved Address",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Poppins",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: savedAddresses.isEmpty
          ? const Center(child: Text("No saved address found."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: savedAddresses.length,
                    itemBuilder: (context, index) {
                      final address = savedAddresses[index];
                      final isSelected = _isSelected(address);
                      return GestureDetector(
                        onTap: () => _onAddressSelected(address),
                        child: Card(
                          color: isSelected
                              ? Colors.green.shade50
                              : Colors.white,
                          elevation: isSelected ? 4 : 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.green
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Radio<AddressModel>(
                                  value: address,
                                  groupValue: savedAddresses.firstWhere(
                                    (addr) => _isSelected(addr),
                                    orElse: () => AddressModel.empty(),
                                  ),
                                  onChanged: (val) => _onAddressSelected(val!),
                                  activeColor: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address.fullAddress,
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          TextButton.icon(
                                            onPressed: () =>
                                                _editAddress(address),
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 18,
                                            ),
                                            label: const Text("Edit"),
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              foregroundColor: Colors.blue,
                                              backgroundColor: Colors.blue
                                                  .withOpacity(0.1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton.icon(
                                            onPressed: () =>
                                                _deleteAddress(address.id),
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 18,
                                            ),
                                            label: const Text("Delete"),
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              foregroundColor: Colors.red,
                                              backgroundColor: Colors.red
                                                  .withOpacity(0.1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: selectedAddress != null ? _onProceed : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Proceed to Payment"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
