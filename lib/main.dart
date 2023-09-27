import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/localeString.dart';
import 'package:flying_horse/app/routes/app_pages.dart';
import 'package:flying_horse/app/utils/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  String initialRoute = Routes.LOGIN;

  if (GetStorage().read('token') != null) {
    initialRoute = Routes.MAIN_NAVIGATION;
  }
  runApp(GetMaterialApp(
    initialRoute: initialRoute,
    getPages: AppPages.routes,
    title: 'Chirper',
    translations: LocaleString(),
    locale: LocaleString.locale,
    fallbackLocale: LocaleString.fallbackLocale,
    theme: AppTheme.theme,
    debugShowCheckedModeBanner: false,
  ));
}
