import 'package:equatable/equatable.dart';

class CustomerAddress {
  final String line1;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  CustomerAddress({
    required this.line1,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
        'line1': line1,
        'city': city,
        'state': state,
        'postalCode': postalCode,
        'country': country,
      };
}

class CustomerDetails {
  final String name;
  final String email;
  final String phone;
  final String description; // ✅ ADDED for customer.description
  final CustomerAddress address;

  CustomerDetails({
    required this.name,
    required this.email,
    required this.phone,
    required this.description, // ✅
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'description': description, // ✅ Include in JSON
        'address': address.toJson(),
      };
}

abstract class PaymentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreatePaymentIntentEvent extends PaymentEvent {
  final int amount;
  final String description; // Used in paymentIntent
  final CustomerDetails customerDetails;
  final Map<String, dynamic>? metadata;

  CreatePaymentIntentEvent({
    required this.amount,
    required this.description,
    required this.customerDetails,
    this.metadata,
  });

  @override
  List<Object?> get props => [amount, description, customerDetails, metadata];
}
