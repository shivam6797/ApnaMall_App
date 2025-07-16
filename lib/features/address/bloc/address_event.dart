import '../data/model/address_model.dart';

abstract class AddressEvent {}

class SaveAddressEvent extends AddressEvent {
  final AddressModel address;
  SaveAddressEvent(this.address);
}

class LoadAddressEvent extends AddressEvent {}
