import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:flying_horse/app/modules/users/users_response.dart';
import 'package:flying_horse/app/utils/text_style.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/users_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:async'; // For Timer
import 'package:intl/intl.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({Key? key}) : super(key: key);

  String formatElapsedTime(DateTime startedAt) {
    final now = DateTime.now(); // Get the local time of the device
    final startedAtLocal =
        startedAt.toLocal(); // Convert startedAt to local time (if it's in UTC)

    // Calculate the time difference
    final difference = now.difference(startedAtLocal);

    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String toTitleCase(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: AppColors.primary,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.primary,
        systemNavigationBarDividerColor: AppColors.primary,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Users'),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: Obx(() => controller.isLoading.value && controller.users.isEmpty
            ? Center(
                child: CupertinoActivityIndicator(color: AppColors.primary),
              )
            : controller.users.isEmpty
                ? Center(
                    child: Text(
                      'No users found',
                      style: AppTextStyle.regularStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await controller.getUsers(1); // Refresh from page 1
                    },
                    child: ListView(
                      controller: controller.scrollController,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Here is the list of',
                                      style: AppTextStyle.regularStyle(
                                        fontSize: 20,
                                        color: Color(0xffBDBDBD),
                                        height: 1.0,
                                      ),
                                    ),
                                    Text(
                                      'All',
                                      style: AppTextStyle.regularStyle(
                                        fontSize: 26,
                                        color: Color(0xffBDBDBD),
                                        height: 1.0,
                                      ),
                                    ),
                                    Text(
                                      'Users',
                                      style: AppTextStyle.semiBoldStyle(
                                        fontSize: 32,
                                        color: Colors.black,
                                        height: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/horse_black.png',
                              height: 138,
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        // Group users by team
                        _buildTeamUserList(),
                      ],
                    ),
                  )),
      ),
    );
  }

  Widget _buildTeamUserList() {
  // Group users by teamId
  final groupedUsers = <String, List<User>>{};

  for (var user in controller.users) {
    final teamId =
        user.teamId?.toString() ?? 'unknown'; // Ensure teamId is a String
    if (!groupedUsers.containsKey(teamId)) {
      groupedUsers[teamId] = [];
    }
    groupedUsers[teamId]!.add(user);
  }

  // List of colors for teams, which you can extend or modify
  final List<Color> teamColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.teal,
  ];

  return ListView.builder(
    padding: EdgeInsets.symmetric(horizontal: 15),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: groupedUsers.keys.length,
    itemBuilder: (context, teamIndex) {
      final teamId = groupedUsers.keys.elementAt(teamIndex);
      final teamUsers = groupedUsers[teamId]!;
      var teamName = teamUsers.first.teamName;

      // Select color based on the teamIndex from the list
      final Color borderColor = teamColors[teamIndex % teamColors.length];
      final Color textColor = borderColor;

      // Capitalize the first letter of teamName if it's not null or empty
      if (teamName != null && teamName.isNotEmpty && teamName.toLowerCase() != 'null') {
        teamName = toBeginningOfSentenceCase(teamName.toLowerCase());
      }

      // Render without dotted border and team name if teamName is null, "null", or empty
      if (teamName == null || teamName.toLowerCase() == 'null' || teamName.isEmpty) {
        return Column(
          children: [
            SizedBox(height: 20), // Space between teams
            Column(
              children: teamUsers.map((user) {
                return Column(
                  children: [
                    _buildUserCard(user),
                    SizedBox(height: 20), // Add spacing between each card
                  ],
                );
              }).toList(),
            ),
          ],
        );
      }

      // Render with dotted border and capitalized team name
      return Column(
        children: [
          SizedBox(height: 30), // Space between teams
          Stack(
            clipBehavior: Clip.none, // Prevent clipping of Positioned widget
            alignment: Alignment.topLeft,
            children: [
              // The dotted border box with dynamic color
              DottedBorder(
                color: borderColor, // Dynamic color for the border
                strokeWidth: 1,
                dashPattern: [3, 3], // Length of dashes and space between them
                borderType: BorderType.RRect, // Rounded border
                radius: Radius.circular(10), // Corner radius
                padding: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 15), // Increased top padding to fit the team name
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20), // Space for team name to overlay
                    Column(
                      children: teamUsers.map((user) {
                        return Column(
                          children: [
                            _buildUserCard(user),
                            SizedBox(height: 15), // Add spacing between each card
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // The team name positioned above the dotted border
              Positioned(
                top: -15, // Adjusted top value to keep it visible
                left: 30, // Position it slightly above the dotted border
                child: Container(
                  color: Colors.white, // Background color for the text
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    teamName ?? '', // Capitalized team name
                    style: AppTextStyle.mediumStyle(
                      fontSize: 20,
                      color: textColor, // Dynamic text color matching the border
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}


  Widget _buildUserCard(User user) {
    DateTime? startedAt;
    if (user.startedAt != null && user.startedAt!.isNotEmpty) {
      startedAt =
          DateFormat("yyyy-MM-dd HH:mm:ss").parseUtc(user.startedAt!).toLocal();
    }

    // Create a Stream for continuous update
    Stream<String> timeStream() async* {
      while (true) {
        if (startedAt != null) {
          yield formatElapsedTime(startedAt); // Update according to startedAt
        }
        await Future.delayed(Duration(seconds: 1)); // Update every second
      }
    }

    // Function to launch the dialer
    Future<void> _launchDialer(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      if (await canLaunch(launchUri.toString())) {
        await launch(launchUri.toString());
      } else {
        Get.snackbar(
          backgroundColor: Colors.white70,
            colorText: Colors.black87,
          'Error', 'Could not launch dialer');
      }
    }

    return GestureDetector(
      onLongPress: () {
        // On long press, open the dialer with the user's phone number
        if (user.phone != null) {
          _launchDialer(user.phone!);
        } else {
          Get.snackbar(
            backgroundColor: Colors.white70,
            colorText: Colors.black87,
            'Error', 'Phone number not available');
        }
      },
      child: Container(
        height: 95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Header padding
  decoration: BoxDecoration(
    color: user.statusId == 1
        ? AppColors.available.withOpacity(0.07)
        : user.statusId == 2
            ? AppColors.mayBe.withOpacity(0.07)
            : user.statusId == 3
                ? AppColors.unavailable.withOpacity(0.07)
                : user.statusId == 4
                    ? AppColors.dnd.withOpacity(0.07)
                    : Colors.grey.withOpacity(0.07), // Background color for the whole header
    borderRadius: BorderRadius.circular(5),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure space between elements
    children: [
      // Status Text
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
          color: user.statusId == 1
              ? AppColors.available
              : user.statusId == 2
                  ? AppColors.mayBe
                  : user.statusId == 3
                      ? AppColors.unavailable
                      : user.statusId == 4
                          ? AppColors.dnd
                          : Colors.grey,// Individual status background
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Text(
          user.statusId == 1
              ? 'Available'
              : user.statusId == 2
                  ? 'May Be Available'
                  : user.statusId == 3
                      ? 'Unavailable'
                      : user.statusId == 4
                          ? 'Do Not Disturb'
                          : 'No status',
          style: AppTextStyle.mediumStyle(
            fontSize: 12,
            color: Colors.white, // Text color
          ),
        ),
      ),
      // Timer
      StreamBuilder<String>(
        stream: timeStream(), // Stream for time updates
        builder: (context, snapshot) {
          return Text(
            snapshot.hasData ? snapshot.data! : '00:00:00',
            style: AppTextStyle.semiBoldStyle(
              fontSize: 14,
              color: Colors.black, // Timer text color
            ),
          );
        },
      ),
    ],
  ),
),

              SizedBox(height: 8),
              // User Name Row
             Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust the padding value as needed
  child: Row(
    children: [
      Expanded(
        child: Text(
          toTitleCase(user.name),
          style: AppTextStyle.semiBoldStyle(
            fontSize: 17,
            color: Colors.black,
          ),
        ),
      ),
    ],
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
