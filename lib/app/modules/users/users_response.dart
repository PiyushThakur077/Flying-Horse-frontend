import 'package:flying_horse/app/modules/login/user.dart';

class UsersResponse {
  List<User>? data;
  bool? success;
  String? message;
  int? statusCode;

  UsersResponse({this.data, this.success, this.message, this.statusCode});

  UsersResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data']['data'] != null) {
      data = <User>[];
      json['data']['data'].forEach((v) {
        data!.add(User.fromJson(v));
      });
    }
    success = json['success'];
    message = json['message'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    data['status_code'] = this.statusCode;
    return data;
  }
}
