class LoginModel {
  bool? success;
  String? message;
  Data? data;
  int? statusCode;
  String? timestamp;

  LoginModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    statusCode = json['status_code'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['success'] = success;
    data['message'] = message;

    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }

    data['status_code'] = statusCode;
    data['timestamp'] = timestamp;

    return data;
  }
}

class Data {
  User? user;
  String? token;
  String? role;
  List<String>? roles;
  bool? mustChangePassword;

  Data({
    this.user,
    this.token,
    this.role,
    this.roles,
    this.mustChangePassword,
  });

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
    role = json['role'];
    roles = json['roles'] != null ? List<String>.from(json['roles']) : [];
    mustChangePassword = json['must_change_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (user != null) {
      data['user'] = user!.toJson();
    }

    data['token'] = token;
    data['role'] = role;
    data['roles'] = roles;
    data['must_change_password'] = mustChangePassword;

    return data;
  }
}

class User {
  int? userId;
  String? fullName;
  String? phone;
  String? email;
  bool? mustChangePassword;
  int? accountStatus;
  String? rating;

  /// تم تعديل هذا الحقل
  String? ratingLastUpdated;

  int? createdBy;
  String? registrationType;
  String? createdAt;
  String? updatedAt;

  /// تمت إضافته لأنه موجود في الـ API
  String? profilePhoto;

  List<Roles>? roles;

  User({
    this.userId,
    this.fullName,
    this.phone,
    this.email,
    this.mustChangePassword,
    this.accountStatus,
    this.rating,
    this.ratingLastUpdated,
    this.createdBy,
    this.registrationType,
    this.createdAt,
    this.updatedAt,
    this.profilePhoto,
    this.roles,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    phone = json['phone'];
    email = json['email'];
    mustChangePassword = json['must_change_password'];
    accountStatus = json['account_status'];
    rating = json['rating']?.toString();
    ratingLastUpdated = json['rating_last_updated'];
    createdBy = json['created_by'];
    registrationType = json['registration_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profilePhoto = json['profile_photo'];

    if (json['roles'] != null) {
      roles = [];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['phone'] = phone;
    data['email'] = email;
    data['must_change_password'] = mustChangePassword;
    data['account_status'] = accountStatus;
    data['rating'] = rating;
    data['rating_last_updated'] = ratingLastUpdated;
    data['created_by'] = createdBy;
    data['registration_type'] = registrationType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['profile_photo'] = profilePhoto;

    if (roles != null) {
      data['roles'] = roles!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class Roles {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }

    return data;
  }
}

class Pivot {
  int? userId;
  int? roleId;

  Pivot({
    this.userId,
    this.roleId,
  });

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'role_id': roleId,
    };
  }
}