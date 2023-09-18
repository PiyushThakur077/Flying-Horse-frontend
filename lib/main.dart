import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/localeString.dart';
import 'package:flying_horse/app/routes/app_pages.dart';
import 'package:flying_horse/app/utils/theme.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    initialRoute: Routes.LOGIN,
    getPages: AppPages.routes,
    title: 'Chirper',
    translations: LocaleString(),
    locale: LocaleString.locale,
    fallbackLocale: LocaleString.fallbackLocale,
    theme: AppTheme.theme,
    debugShowCheckedModeBanner: false,
  ));
}