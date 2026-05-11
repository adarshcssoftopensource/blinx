import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/social_pulse_screen/bluetooth_screen/model/bluetooth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlinxBluetoothService {
  final BaseApiService _apiService = BaseApiService();

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  Future<void> registerDevice(Map<String, dynamic> body) async {
    final token = await _getToken();
    await _apiService.post(
      'mobile/bluetooth/register',
      body,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<void> deregisterDevice() async {
    final token = await _getToken();
    await _apiService.post(
      'mobile/bluetooth/deregister',
      {},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<List<NearbyBlinxUser>> fetchNearbyUsers(double lat, double lng) async {
    final token = await _getToken();
    final response = await _apiService.get(
      'mobile/bluetooth/nearby?latitude=$lat&longitude=$lng&radiusMeters=100',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.data['success'] == true) {
      final users = List<Map<String, dynamic>>.from(response.data['users']);
      return users.map((u) => NearbyBlinxUser.fromJson(u)).toList();
    }
    return [];
  }
}
