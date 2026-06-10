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
  final ProfileSubscriptionStatus? isSubsribed;
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
    this.isSubsribed,
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
    final subscriptionJson = json['isSubsribed'] ?? json['isSubscribed'];
    return UserData(
      avatar: Avatar.fromJson(json['avatar'] ?? {}),
      isSubsribed: ProfileSubscriptionStatus.fromDynamic(subscriptionJson),
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
      'isSubsribed': isSubsribed?.toJson(),
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

class ProfileSubscriptionStatus {
  final bool isTrueOrFalse;
  final DateTime? date;

  const ProfileSubscriptionStatus({required this.isTrueOrFalse, required this.date});

  factory ProfileSubscriptionStatus.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date']?.toString();
    return ProfileSubscriptionStatus(
      isTrueOrFalse: _readBool(json['isTrueOrFalse']),
      date: rawDate == null || rawDate.isEmpty ? null : DateTime.tryParse(rawDate),
    );
  }

  static ProfileSubscriptionStatus? fromDynamic(dynamic value) {
    if (value is Map<String, dynamic>) {
      return ProfileSubscriptionStatus.fromJson(value);
    }
    if (value == null) return null;

    return ProfileSubscriptionStatus(
      isTrueOrFalse: _readBool(value),
      date: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isTrueOrFalse': isTrueOrFalse,
      'date': date?.toIso8601String(),
    };
  }

  static bool _readBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }
    return false;
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
