import 'package:shared_preferences/shared_preferences.dart';

class StoreServices {
  static const String deviceIdKey = 'device_id';
  static const String stewardKey = 'steward_key';
  static const String deviceTypeKey = 'device_type';
  static const String fcmTokenKey = 'fcm_token_key';
  static const String authTokenKey = 'auth_token_key';
  static const String sessionTokenKey = 'session_token';
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userNameKey = 'user_name';
  static const String profileImageKey = 'profile_image';

  // Save device ID locally
  static Future<void> saveDeviceId(String deviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(deviceIdKey, deviceId);
  }

  // Save profile complete status
  static Future<void> saveProfileComplete(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('profile_complete', value);
  }

  // Get profile complete status
  static Future<bool> getProfileComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('profile_complete') ?? false;
  }

  // Get stored device ID
  static Future<String?> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(deviceIdKey);
  }

  // Remove stored device ID
  static Future<void> clearDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(deviceIdKey);
  }

  // Save user name locally
  static Future<void> saveUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, name);
  }

  // Get stored user name
  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  // Get basic user info (name & profile image)
  static Future<Map<String, String?>> getUserBasicInfo() async {
    final name = await getUserName();
    final image = await getProfileImage();
    return {'name': name, 'image': image};
  }

  // Remove stored user name
  static Future<void> clearUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userNameKey);
  }

  // Save steward status locally
  static Future<void> saveStewardStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('steward_status', value);
  }

  // Get steward status
  static Future<bool> getStewardStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('steward_status') ?? false;
  }

  // Remove steward status
  static Future<void> clearStewardStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(stewardKey);
  }

  // Save device type (Android/iOS)
  static Future<void> saveDeviceType(String deviceType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(deviceTypeKey, deviceType);
  }

  // Get stored device type
  static Future<String?> getDeviceType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(deviceTypeKey);
  }

  // Remove stored device type
  static Future<void> clearDeviceType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(deviceTypeKey);
  }

  // Save FCM token
  static Future<void> saveFcmToken(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(fcmTokenKey, fcmToken);
  }

  // Get stored FCM token
  static Future<String?> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(fcmTokenKey);
  }

  // Remove FCM token
  static Future<void> clearFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(fcmTokenKey);
  }

  // Save access token
  static Future<void> saveAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessToken, token);
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessToken);
  }

  static Future<void> saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', id);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  // Remove access token
  static Future<void> clearAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessToken);
  }

  // Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(refreshToken, token);
  }

  // Get stored refresh token
  static Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshToken);
  }

  // Remove refresh token
  static Future<void> clearRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(refreshToken);
  }

  // Save session token
  static Future<void> saveSessionToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sessionTokenKey, token);
  }

  // Get stored session token
  static Future<String?> getSessionToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sessionTokenKey);
  }

  // Remove session token
  static Future<void> clearSessionToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(sessionTokenKey);
  }

  // Save profile image URL
  static Future<void> saveProfileImage(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(profileImageKey, imageUrl);
  }

  // Get stored profile image URL
  static Future<String?> getProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(profileImageKey);
  }

  // Remove profile image
  static Future<void> clearProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(profileImageKey);
  }

  // Clear all stored data
  static Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
