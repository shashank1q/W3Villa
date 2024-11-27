import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/utils/constants.dart';

Future<String> signout() async {
  try {
    await SharedPreferencesAsync().clear();
    return MyConstants.success;
  } catch (e) {
    return e.toString();
  }
}

Future<String> signup(String email, String password) async {
  try {
    final res = await Dio().post("${MyConstants.apiUrl}auth/register",
        options: Options(contentType: Headers.jsonContentType),
        data: {"email": email, "password": password});
    await SharedPreferencesAsync().setString('token', res.data);
    return MyConstants.success;
  } catch (e) {
    return e.toString();
  }
}

Future<String> signIn(String email, String password) async {
  try {
    final res = await Dio().post("${MyConstants.apiUrl}auth/login",
        options: Options(contentType: Headers.jsonContentType),
        data: {"email": email, "password": password});
    await SharedPreferencesAsync().setString('token', res.data);
    return MyConstants.success;
  } catch (e) {
    if (e is DioException) {
      return e.response!.data.toString();
    }
    return e.toString();
  }
}

Future<String> isValid() async {
  try {
    final token = await SharedPreferencesAsync().getString('token');
    await Dio().get("${MyConstants.apiUrl}auth/isvalid",
        options: Options(
            contentType: Headers.jsonContentType,
            headers: {'Authorization': 'Bearer $token'}));
    return MyConstants.success;
  } catch (e) {
    return e.toString();
  }
}
