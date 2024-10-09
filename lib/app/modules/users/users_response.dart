class UserResponse {
  final bool success;
  final String message;
  final int statusCode;
  final UserData? data;

  UserResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      statusCode: json['status_code'] != null
          ? int.tryParse(json['status_code'].toString()) ?? 0 // Provide default value
          : 0, // Default if null
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
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
      page: json['page'] != null
          ? int.tryParse(json['page'].toString()) ?? 1 // Default to page 1 if null
          : 1,
      perPage: json['per_page'] != null
          ? int.tryParse(json['per_page'].toString()) ?? 50 // Default to 50 if null
          : 50,
      total: json['total'] != null
          ? int.tryParse(json['total'].toString()) ?? 0 // Default to 0 if null
          : 0,
      teams: (json['data'] as List? ?? []).map((teamJson) => Team.fromJson(teamJson)).toList(),
    );
  }
}

class Team {
  final int? teamId; // Allow null values for teamId
  final String teamName;
  final List<User> users;

  Team({
    this.teamId, // No need for required since it can be null
    required this.teamName,
    required this.users,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['team_id'] != null
          ? int.tryParse(json['team_id'].toString())
          : null, // Handle null values for team_id
      teamName: json['team_name'] as String? ?? 'Unknown', // Default if null
      users: (json['users'] as List? ?? [])
          .map((userJson) => User.fromJson(userJson))
          .toList(),
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
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0, // Default if null
      role: json['role'] as String? ?? 'Unknown', // Default if null
      statusId: json['status_id'] != null
          ? int.tryParse(json['status_id'].toString())
          : null,
      deviceId: json['device_id'] as String?,
      provider: json['provider'] as String?,
      providerId: json['provider_id'] as String?,
      name: json['name'] as String? ?? 'Unknown', // Default if null
      email: json['email'] as String? ?? 'Unknown', // Default if null
      emailVerifiedAt: json['email_verified_at'] as String?,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      active: json['active'] != null
          ? int.tryParse(json['active'].toString()) ?? 0 // Default if null
          : 0,
      createdAt: json['created_at'] as String? ?? 'Unknown', // Default if null
      updatedAt: json['updated_at'] as String? ?? 'Unknown', // Default if null
      superAdmin: json['super_admin'] != null
          ? int.tryParse(json['super_admin'].toString()) ?? 0 // Default if null
          : 0,
      superUser: json['super_user'] != null
          ? int.tryParse(json['super_user'].toString()) ?? 0 // Default if null
          : 0,
      status: json['status'] as String?,
      startedAt: json['started_at'] as String?,
      teamId: json['team_id'] != null
          ? int.tryParse(json['team_id'].toString())
          : null,
      teamName: json['team_name'] as String?,
    );
  }
}