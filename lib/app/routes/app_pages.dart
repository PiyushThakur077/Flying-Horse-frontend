import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/refuel/bindings/refuel_binding.dart';
import '../modules/refuel/views/refuel_view.dart';
import '../modules/refuel_card/bindings/refuel_card_binding.dart';
import '../modules/refuel_card/views/refuel_card_view.dart';
import '../modules/refueling/bindings/refueling_binding.dart';
import '../modules/refueling/views/refueling_view.dart';
import '../modules/users/bindings/users_binding.dart';
import '../modules/users/views/users_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_NAVIGATION,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.USERS,
      page: () => const UsersView(),
      binding: UsersBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.REFUELING,
      page: () => const RefuelingView(),
      binding: RefuelingBinding(),
    ),
    GetPage(
      name: _Paths.REFUEL,
      page: () => const RefuelView(),
      binding: RefuelBinding(),
    ),
    GetPage(
      name: _Paths.REFUEL_CARD,
      page: () => const RefuelCardView(),
      binding: RefuelCardBinding(),
    ),
  ];
}
