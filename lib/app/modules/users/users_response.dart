class UserResponse {
  final bool success;
  final String message;
  final int statusCode;
  final UserData data;

  UserResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'],
      message: json['message'],
      statusCode: json['status_code'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final int page;
  final int perPage;
  final int total;
  final List<Team> teams;

  UserData({
    required this.page,
    required this.perPage,
    required this.total,
    required this.teams,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      page: json['page'],
      perPage: json['per_page'],
      total: json['total'],
      teams: (json['data'] as List).map((teamJson) => Team.fromJson(teamJson)).toList(),
    );
  }
}

class Team {
  final int teamId;
  final String teamName;
  final List<User> users;

  Team({
    required this.teamId,
    required this.teamName,
    required this.users,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['team_id'],
      teamName: json['team_name'],
      users: (json['users'] as List).map((userJson) => User.fromJson(userJson)).toList(),
    );
  }
}

class User {
  final int id;
  final String role;
  final int? statusId;
  final String? deviceId;
  final String? provider;
  final String? providerId;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? phone;
  final String? image;
  final int active;
  final String createdAt;
  final String updatedAt;
  final int superAdmin;
  final int superUser;
  final String? status;
  final String? startedAt;
  final int? teamId;
  final String? teamName;

  User({
    required this.id,
    required this.role,
    this.statusId,
    this.deviceId,
    this.provider,
    this.providerId,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.phone,
    this.image,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.superAdmin,
    required this.superUser,
    this.status,
    this.startedAt,
    this.teamId,
    this.teamName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      role: json['role'],
      statusId: json['status_id'],
      deviceId: json['device_id'],
      provider: json['provider'],
      providerId: json['provider_id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      phone: json['phone'],
      image: json['image'],
      active: json['active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      superAdmin: json['super_admin'],
      superUser: json['super_user'],
      status: json['status'],
      startedAt: json['started_at'],
      teamId: json['team_id'],
      teamName: json['team_name'],
    );
  }
}