import 'package:flying_horse/app/modules/login/user.dart';

class UsersResponse {
  List<User>? data;
  bool? success;
  String? message;
  int? statusCode;
  int? currentPage; // Add this if your API response includes it
  int? lastPage; // Add this if your API response includes it

  UsersResponse({
    this.data,
    this.success,
    this.message,
    this.statusCode,
    this.currentPage,
    this.lastPage,
  });

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
    currentPage = json['data']['current_page']; // Adjust according to your API response
    lastPage = json['data']['last_page']; // Adjust according to your API response
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    data['status_code'] = this.statusCode;
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    return data;
  }
}
