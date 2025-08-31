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

class UserProfile {
  final Avatar avatar;
  final String id;
  final String name;
  final String email;
  final String phone;
  final dynamic credit;
  final String role;
  final bool enableNotifications;
  final bool dnd;
  final int totalPosts;
  final String address;
  final int fine;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  UserProfile({
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
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
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
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      v: json['__v'] ?? 0,
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
    };
  }
}

class ApiResponse {
  final bool success;
  final String message;
  final UserProfile? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UserProfile.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
