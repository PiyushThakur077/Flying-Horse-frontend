import 'dart:developer';
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
    return await postApi(
      'api/login',
      map,
      headers: {'accept': 'application/json'},
      contentType: 'application/json',
    );
  }

  Future<dynamic> getUsers(String page) async {
    return await getApi('api/users',
        headers: {
          'accept': 'application/json',
          'Authorization': "Bearer ${GetStorage().read('token')}"
        },
        query: {'page': page},
        contentType: 'application/json');
  }

  Future<dynamic> getUser() async {
    return await getApi('api/user',
        headers: {
          'accept': 'application/json',
          'Authorization': "Bearer ${GetStorage().read('token')}"
        },
        contentType: 'application/json');
  }

  Future<dynamic> updateStatus(Map map) async {
    return await postApi('api/updateStatus', map,
        headers: {
          'accept': 'application/json',
          'Authorization': "Bearer ${GetStorage().read('token')}"
        },
        contentType: 'application/json');
  }

  Future<dynamic> getTrip() async {
    return await getApi('api/user/trips',
        headers: {
          'accept': 'application/json',
          'Authorization': "Bearer ${GetStorage().read('token')}"
        },
        contentType: 'application/json');
  }

  Future<dynamic> getTripId(int id) async {
    return await getApi('api/user/trips/$id',
        headers: {
          'accept': 'application/json',
          'Authorization': "Bearer ${GetStorage().read('token')}"
        },
        contentType: 'application/json');
  }

  Future<dynamic> saveFuelDetails(Map map) async {
    return await postApi('api/user/refuelings', map,
        headers: {
          'accept': 'application/json',
          'Authorization': "Bearer ${GetStorage().read('token')}"
        },
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
      Get.back();
      Widgets.showAppDialog(isError: true, description: ErrorHandler(response));
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
    log(response.status.toString());
    log(response.body.toString());

    if (response.status.hasError) {
      if (isLoading) {
        Get.back();
      }
      Widgets.showAppDialog(isError: true, description: ErrorHandler(response));
      return Future.error(response.statusText!);
    } else {
      print(response.body);
      return response.body;
    }
  }

  dynamic ErrorHandler(Response response) {
    print(response.toString());
    if (response.status.connectionError) {
      return 'Error occurred pls check internet and retry.';
    } else {
      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
          var responseJson = response.body;
          return responseJson;
        case 400:
          var responseJson = response.body['message'] is String
              ? response.body['message']
              : response.body['message'][0];
          return responseJson;
        case 500:
          return "Server Error pls retry later";
        case 403:
          return 'Error occurred pls retry.';
        case 401:
          return 'Unauthorised.';
        default:
          return 'Error occurred retry';
      }
    }
  }
}
