import 'package:blinx_mobile/business_logic/api_response.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/saved_places/saved_place_model.dart';
import 'package:dio/dio.dart';

class SavedPlacesService {
  final Dio _dio = Dio();

  Future<ApiResponse<List<SavedPlaceModel>>> getSavedPlaces() async {
    try {
      final token = await StoreServices.getAccessToken();

      final response = await _dio.get(
        'https://civicfind-api-staging-110912028053.us-central1.run.app/plans/saved-places',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final body = response.data;

      if (body['status'] == true) {
        final List data = body['data'];
        final places = data.map((e) => SavedPlaceModel.fromJson(e)).toList();
        return ApiResponse(
          success: true,
          message: body['message'] ?? 'Success',
          data: places,
        );
      } else {
        return ApiResponse(
          success: false,
          message: body['message'] ?? 'Something went wrong',
          data: null,
        );
      }
    } catch (e) {
      return handleDioError<List<SavedPlaceModel>>(e);
    }
  }
}
