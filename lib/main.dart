import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flying_horse/app/data/localeString.dart';
import 'package:flying_horse/app/routes/app_pages.dart';
import 'package:flying_horse/app/utils/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Future.delayed(Duration(seconds: 1));

  String initialRoute = Routes.LOGIN;

  if (GetStorage().read('token') != null) {
    initialRoute = Routes.MAIN_NAVIGATION;
  }

  //  initConnectivity();

  // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //   Get.showSnackbar(
  //     GetSnackBar(
  //       backgroundColor:
  //           result == ConnectivityResult.none ? Colors.red : Colors.green,
  //       // title: 'Error',
  //       message: result == ConnectivityResult.none
  //           ? 'No internet connection'
  //           : 'Internet connection restored',
  //       duration: const Duration(seconds: 3),
  //     ),
  //   );
  // });

  // Future<void> initConnectivity() async {
  //   late ConnectivityResult result;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await Connectivity().checkConnectivity();
  //   } on PlatformException catch (e) {
  //     log('Couldn\'t check connectivity status', error: e);
  //     return;
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   // if (!mounted) {
  //   //   return Future.value(null);
  //   // }
  //   connectionStatus.value = result;
  //   // return result;
  // }
  runApp(GetMaterialApp(
    initialRoute: initialRoute,
    getPages: AppPages.routes,
    title: 'Flying horse',
    translations: LocaleString(),
    locale: LocaleString.locale,
    fallbackLocale: LocaleString.fallbackLocale,
    theme: AppTheme.theme,
    debugShowCheckedModeBanner: false,
  ));
}
