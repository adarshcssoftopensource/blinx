//import 'package:shared_preferences/shared_preferences.dart';

class StoreServices {
  static const String deviceIdKey = 'device_id';
  static const String deviceTypeKey = 'device_type';
  static const String fcmTokenKey = 'fcm_token_key';
  static const String authTokenKey = 'auth_token_key';
  static const String sessionTokenKey = 'session_token';
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String user = 'first_user';

  static Future<void> saveDeviceId(String deviceId) async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //  await prefs.setString(deviceIdKey, deviceId);
  }

  static Future<String?> getDeviceId() async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //  return prefs.getString(deviceIdKey);
  }

  static Future<void> clearDeviceId() async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove(deviceIdKey);
  }

  static Future<void> saveDeviceType(String deviceType) async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString(deviceTypeKey, deviceType);
  }

  static Future<String?> getDeviceType() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getString(deviceTypeKey);
  }

  static Future<void> clearDeviceType() async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //  await prefs.remove(deviceTypeKey);
  }

  static Future<void> saveFcmToken(String fcmToken) async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString(fcmTokenKey, fcmToken);
  }

  static Future<String?> getFcmToken() async {
    // // SharedPreferences prefs = await SharedPreferences.getInstance();
    //  return prefs.getString(fcmTokenKey);
  }

  static Future<void> clearFcmToken() async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //  await prefs.remove(fcmTokenKey);
  }

  static Future<void> saveAccessToken(String deviceId) async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //  await prefs.setString(accessToken, deviceId);
  }

  static Future<String?> getAccessToken() async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //  return prefs.getString(accessToken);
  }

  static Future<void> clearAccessToken() async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //  await prefs.remove(accessToken);
  }

  static Future<void> saveRefreshToken(String deviceId) async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //  await prefs.setString(refreshToken, deviceId);
  }

  static Future<String?> getRefreshToken() async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //  return prefs.getString(refreshToken);
  }

  static Future<void> clearRefreshToken() async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //  await prefs.remove(refreshToken);
  }

  static Future<void> saveUser(bool firstUser) async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //  await prefs.setBool(user, firstUser);
  }

  static Future<bool?> getUser() async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //  return prefs.getBool(user);
  }

  static Future<void> clearUser() async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove(user);
  }
}
