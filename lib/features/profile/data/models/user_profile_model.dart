class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String image;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.image,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile_number'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile_number': mobile,
      'image': image,
    };
  }
}
