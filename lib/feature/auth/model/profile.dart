class ProfileModel {
  final String id;
  final String name;
  final String companyName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String role;
  final bool isActive;
  final String? resetPasswordOTP;
  final String? resetPasswordExpires;
  final int totalOrders;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.companyName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.role,
    required this.isActive,
    this.resetPasswordOTP,
    this.resetPasswordExpires,
    required this.totalOrders,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["_id"],
      name: json["name"],
      companyName: json["companyName"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      profileImage: json["profileImage"],
      role: json["role"],
      isActive: json["isActive"] ?? true,
      resetPasswordOTP: json["resetPasswordOTP"],
      resetPasswordExpires: json["resetPasswordExpires"],
      totalOrders: json["totalOrders"] ?? 0,
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "companyName": companyName,
      "email": email,
      "phoneNumber": phoneNumber,
      "profileImage": profileImage,
      "role": role,
      "isActive": isActive,
      "resetPasswordOTP": resetPasswordOTP,
      "resetPasswordExpires": resetPasswordExpires,
      "totalOrders": totalOrders,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
