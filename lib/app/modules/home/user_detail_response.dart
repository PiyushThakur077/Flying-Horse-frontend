import 'package:flying_horse/app/modules/login/user.dart';

class UserDetailResponse {
  User? data;
  bool? success;
  String? message;
  int? statusCode;

  UserDetailResponse({this.data, this.success, this.message, this.statusCode});

  UserDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new User.fromJson(json['data']) : null;
    success = json['success'];
    message = json['message'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    data['status_code'] = this.statusCode;
    return data;
  }
}
