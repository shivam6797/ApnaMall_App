class UserModel {
  final bool status;
  final String message;
  final String token;

  UserModel({
    required this.status,
    required this.message,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['tokan'] ?? '',
    );
  }
}
