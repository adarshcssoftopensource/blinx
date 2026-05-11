import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:dio/dio.dart';

class NearbySafetyServices {
  final BaseApiService _apiService = BaseApiService();

  Future<Response> fetchNearbyBlinks({
    required double latitude,
    required double longitude,
  }) async {
    final token = await StoreServices.getAccessToken();
    return _apiService.get(
      'mobile/social/blinks/nearby?latitude=$latitude&longitude=$longitude',
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
