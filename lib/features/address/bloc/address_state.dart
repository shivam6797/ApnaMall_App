import '../data/model/address_model.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressSaved extends AddressState {
  final AddressModel address;
  AddressSaved({required this.address});
}

class AddressLoaded extends AddressState {
  final AddressModel address;
  AddressLoaded({required this.address});
}
