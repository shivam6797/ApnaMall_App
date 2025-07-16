class CouponModel {
  final String code;
  final String description;
  final double discountAmount;
  final String? validTill;

  CouponModel({
    required this.code,
    required this.description,
    required this.discountAmount,
    required this.validTill,

  });
}
