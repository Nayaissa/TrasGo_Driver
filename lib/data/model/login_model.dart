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
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    statusCode = json['status_code'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status_code'] = this.statusCode;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Data {
  User? user;
  String ? token;
  String? role;
  List<String>? roles;
  bool? mustChangePassword;

  Data({this.user, this.token, this.role, this.roles, this.mustChangePassword});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
    role = json['role'];
    roles = json['roles'].cast<String>();
    mustChangePassword = json['must_change_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    data['role'] = this.role;
    data['roles'] = this.roles;
    data['must_change_password'] = this.mustChangePassword;
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
  Null ratingLastUpdated;
  int? createdBy;
  String? registrationType;
  String? createdAt;
  String? updatedAt;
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
    this.roles,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    phone = json['phone'];
    email = json['email'];
    mustChangePassword = json['must_change_password'];
    accountStatus = json['account_status'];
    rating = json['rating'];
    ratingLastUpdated = json['rating_last_updated'];
    createdBy = json['created_by'];
    registrationType = json['registration_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['must_change_password'] = this.mustChangePassword;
    data['account_status'] = this.accountStatus;
    data['rating'] = this.rating;
    data['rating_last_updated'] = this.ratingLastUpdated;
    data['created_by'] = this.createdBy;
    data['registration_type'] = this.registrationType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
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

  Roles({this.id, this.name, this.createdAt, this.updatedAt, this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? userId;
  int? roleId;

  Pivot({this.userId, this.roleId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['role_id'] = this.roleId;
    return data;
  }
}
