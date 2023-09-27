import 'package:flying_horse/app/data/constants.dart';
import 'package:flying_horse/app/modules/login/user.dart';
import 'package:flying_horse/app/widgets/dialogs.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return User.fromJson(map);
      if (map is List) return map.map((item) => User.fromJson(item)).toList();
    };
    httpClient.baseUrl = Constants.baseUrl;
  }

  Future<dynamic> signIn(Map map) async {
    return await postApi('api/login', map,
        headers: {}, contentType: 'application/json');
  }

  Future<dynamic> getUsers() async {
    return await getApi('api/users',
        headers: {'Authorization': "Bearer ${GetStorage().read('token')}"},
        contentType: 'application/json');
  }

  Future<dynamic> getUser() async {
    return await getApi('api/user',
        headers: {'Authorization': "Bearer ${GetStorage().read('token')}"},
        contentType: 'application/json');
  }

  Future<dynamic> updateStatus(Map map) async {
    return await postApi('api/updateStatus', map,
        headers: {'Authorization': "Bearer ${GetStorage().read('token')}"},
        contentType: 'application/json');
  }

  Future<dynamic> postApi(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Progress? uploadProgress}) async {
    httpClient.timeout = const Duration(seconds: 35);
    final response = await post(Constants.baseUrl + url!, body,
        contentType: contentType, headers: headers);
    if (response.status.hasError) {
      // if (isLoading) {
      Get.back();
      // }
      Widgets.showAppDialog(
          isError: true, description: response.body['message']);
      return Future.error(response.statusText!);
    } else {
      print(response.body);
      return response.body;
    }
  }

  Future<dynamic> postApiWithoutError(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Progress? uploadProgress}) async {
    httpClient.timeout = const Duration(seconds: 35);
    final response = await post(Constants.baseUrl + url!, body,
            contentType: contentType, headers: headers)
        .timeout(const Duration(seconds: 25));
    return response.body;
  }

  Future<dynamic> getApi(String? url,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      bool isLoading = false}) async {
    httpClient.timeout = const Duration(seconds: 35);
    final response = await get(Constants.baseUrl + url!,
        contentType: contentType, headers: headers, query: query);
    if (response.status.hasError) {
      if (isLoading) {
        Get.back();
      }
      Widgets.showAppDialog(
          isError: true, description: response.body['message']);
      return Future.error(response.statusText!);
    } else {
      print(response.body);
      return response.body;
    }
  }
}
