import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String clientSecret;

  PaymentSuccess(this.clientSecret);

  @override
  List<Object?> get props => [clientSecret];
}

class PaymentFailure extends PaymentState {
  final String error;

  PaymentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
