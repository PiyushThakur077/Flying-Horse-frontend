class LoginResponse {
  bool? success;
  String? message;
  UserData? data;

  LoginResponse({this.success, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  User? user;
  String? token;

  UserData({this.user, this.token});

  UserData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  int? id;
  String? role;
  int? statusId;
  // Null? deviceId;
  // Null? provider;
  // Null? providerId;
  String? name;
  String? email;
  // Null? emailVerifiedAt;
  String? phone;
  // Null? image;
  int? active;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.role,
      this.statusId,
      // this.deviceId,
      // this.provider,
      // this.providerId,
      this.name,
      this.email,
      // this.emailVerifiedAt,
      this.phone,
      // this.image,
      this.active,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    statusId = json['status_id'];
    // deviceId = json['device_id'];
    // provider = json['provider'];
    // providerId = json['provider_id'];
    name = json['name'];
    email = json['email'];
    // emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    // image = json['image'];
    active = json['active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['status_id'] = this.statusId;
    // data['device_id'] = this.deviceId;
    // data['provider'] = this.provider;
    // data['provider_id'] = this.providerId;
    data['name'] = this.name;
    data['email'] = this.email;
    // data['email_verified_at'] = this.emailVerifiedAt;
    data['phone'] = this.phone;
    // data['image'] = this.image;
    data['active'] = this.active;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
