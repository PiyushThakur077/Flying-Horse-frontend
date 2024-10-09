import 'package:flutter/cupertino.dart';
import 'package:flying_horse/app/data/api_provider.dart';
import 'package:flying_horse/app/data/colors.dart';
import 'package:get/get.dart';
import 'package:flying_horse/app/modules/users/users_response.dart';

class UsersController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<User> users = <User>[].obs;
  ScrollController scrollController = ScrollController();
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getUsers(1);
    scrollControllerListener();
  }

  void scrollControllerListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (currentPage.value < lastPage.value && !isLoading.value) {
          currentPage.value++;
          getUsers(currentPage.value);
        }
      }
    });
  }

 Future<void> getUsers(int page) async {
  print("getUsers started for page: $page");

  if (page == 1) {
    isLoading.value = true;
  } else {
    Get.dialog(
      Center(
        child: CupertinoActivityIndicator(
          color: AppColors.primary,
        ),
      ),
      barrierDismissible: false,
    );
  }

  try {
    var resp = await ApiProvider().getUsers(page, perPage: 50);

    // Log the raw response from the API
    print("API Response: $resp");

    // Parse the response into the UserResponse object
    UserResponse? userResponse;
    try {
      userResponse = UserResponse.fromJson(resp);
      print(
          "Parsed UserResponse: ${userResponse.data?.teams.length ?? 0} teams found");
    } catch (e) {
      print("Error while parsing response: $e");
      return;
    }

    if (page == 1) {
      users.clear(); // Clear previous data when fetching page 1
    }

    // Proceed only if userResponse and its data are valid
    if (userResponse != null && userResponse.data?.teams.isNotEmpty == true) {
      for (var team in userResponse.data!.teams) {
        // Log the users under the current team
        print("Processing team: ${team.teamName} with ${team.users.length} users");

        if (team.users.isNotEmpty) {
          users.addAll(team.users); // Add users to the list
          print("Added ${team.users.length} users from team: ${team.teamName}");
        }
      }

      // Calculate lastPage using total and perPage if present
      lastPage.value =
          (userResponse.data!.total / userResponse.data!.perPage).ceil();
    } else {
      print("User response or teams data is null or empty");
    }

    print("Total Users in List: ${users.length}");
  } catch (e) {
    print("Error during API call or data processing: $e");
  } finally {
    isLoading.value = false;
    if (page > 1) {
      Get.back(); // Close loading dialog after fetching paginated data
    }
  }
}
}
