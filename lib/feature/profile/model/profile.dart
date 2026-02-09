class UserProfileModel {
  final bool success;
  final String message;
  final UserData data;

  UserProfileModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final Avatar avatar;
  final String id;
  final String name;
  final String email;
  final String phone;
  final int? credit;
  final String role;
  final bool enableNotifications;
  final bool dnd;
  final int totalPosts;
  final String address;
  final int fine;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String gender;

  UserData({
    required this.avatar,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.credit,
    required this.role,
    required this.enableNotifications,
    required this.dnd,
    required this.totalPosts,
    required this.address,
    required this.fine,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.gender,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      avatar: Avatar.fromJson(json['avatar'] ?? {}),
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      credit: json['credit'],
      role: json['role'] ?? '',
      enableNotifications: json['enableNotifications'] ?? false,
      dnd: json['dnd'] ?? false,
      totalPosts: json['totalPosts'] ?? 0,
      address: json['address'] ?? '',
      fine: json['fine'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      v: json['__v'] ?? 0,
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar.toJson(),
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'credit': credit,
      'role': role,
      'enableNotifications': enableNotifications,
      'dnd': dnd,
      'totalPosts': totalPosts,
      'address': address,
      'fine': fine,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'gender': gender,
    };
  }
}

class Avatar {
  final String publicId;
  final String url;

  Avatar({
    required this.publicId,
    required this.url,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      publicId: json['public_id'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'url': url,
    };
  }
}
