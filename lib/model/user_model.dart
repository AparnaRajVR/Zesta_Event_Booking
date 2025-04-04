
class UserModel {
  final String fullName;
  final String email;
  final String? phone;
  final String? organizerType;
  final String? orgName;
  final String? address;
  final String? profileImageUrl;

  UserModel({
    required this.fullName,
    required this.email,
    this.phone,
    this.organizerType,
    this.orgName,
    this.address,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'organizerType': organizerType,
      'orgName': orgName,
      'address': address,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      organizerType: json['organizerType'],
      orgName: json['orgName'],
      address: json['address'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}

