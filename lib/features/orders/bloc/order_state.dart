abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final String message;
  OrderSuccess(this.message);
}

class OrderFailure extends OrderState {
  final String error;
  OrderFailure(this.error);
}
