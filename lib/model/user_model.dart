class UserModel {
  final String fullName;
  final String email;

  UserModel({
    required this.fullName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      email: json['email'],
    );
  }
}