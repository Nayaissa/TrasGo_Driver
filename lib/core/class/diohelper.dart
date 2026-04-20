import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:transport_project/core/services/service.dart';

late final MyServices myServices = Get.find();

class DioHelper {
  static dio.Dio? dioClient;

  /// Initialize Dio with base settings
  static void init() {
    dioClient = dio.Dio(
      dio.BaseOptions(
        baseUrl: 'http://10.0.2.2:8000/api/',
        connectTimeout: Duration(seconds: 50),
        validateStatus: (status) => true,
        receiveDataWhenStatusError: false,
      ),
    );
  }

  /// Basic GET request without token
  static Future<dio.Response?> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
  }) async {
    try {
      dioClient!.options.headers = {};
      return await dioClient?.get(url, queryParameters: query);
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  /// GET request with token from shared preferences
  static Future<dio.Response?> getDataa({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
  }) async {
    try {
      String? token = myServices.sharedPreferences.getString('token') ?? '';
      print('{Token from SharedPreferences: $token}');

      dioClient!.options.headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      return await dioClient?.get(url, queryParameters: query);
    } catch (e, s) {
      print('Error fetching data: $e');
      print('StackTrace: $s');
      return null;
    }
  }

  /// POST request without token
  Future<dio.Response?> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
  }) async {
    try {
      dioClient!.options.headers = {'Accept': 'application/json'};
      return await dioClient?.post(url, queryParameters: query, data: data);
    } catch (e) {
      print('Error posting data: $e');
      return null;
    }
  }

  /// POST request with token from shared preferences
  static Future<dio.Response?> postsData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
  }) async {
    try {
      String? token = myServices.sharedPreferences.getString('token') ?? '';

      dioClient!.options.headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer 2|e5YjLIwJNb1gKhS8vPTIdDVauC8uueiVKb3Ud1g656a1e7cc',
      };

      return await dioClient?.post(url, queryParameters: query, data: data);
    } catch (e) {
      print('Error posting data: $e');
      return null;
    }
  }

  /// PUT request with token from shared preferences
  static Future<dio.Response?> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'ar',
  }) async {
    try {
      String? token = myServices.sharedPreferences.getString('token') ?? '';

      dioClient!.options.headers = {
        'Content-Type': 'application/json',
        'lang': lang,
        'Authorization': 'Bearer $token',
      };

      return await dioClient?.put(url, queryParameters: query, data: data);
    } catch (e) {
      print('Error putting data: $e');
      return null;
    }
  }

  /// DELETE request with token from shared preferences
  static Future<dio.Response?> deleteData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
  }) async {
    try {
      String? token = myServices.sharedPreferences.getString('token') ?? '';

      dioClient!.options.headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      return await dioClient?.delete(url, queryParameters: query, data: data);
    } catch (e) {
      print('Error deleting data: $e');
      return null;
    }
  }
}
