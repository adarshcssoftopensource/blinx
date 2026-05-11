import 'package:blinx_mobile/social_pulse_screen/nearby_safety_screen/model/nearby_safety_model.dart';
import 'package:blinx_mobile/social_pulse_screen/nearby_safety_screen/services/nearby_safety_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class NearbySafetyController extends GetxController {
  final NearbySafetyServices _services = NearbySafetyServices();

  var blinks = <NearbySafetyModel>[].obs;
  var isLoading = false.obs;
  var locationError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNearbyBlinks();
  }

  Future<void> fetchNearbyBlinks() async {
    try {
      isLoading.value = true;
      locationError.value = '';

      LocationPermission permission = await Geolocator.checkPermission();
      print('Permission status: $permission');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print('After request: $permission');
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        locationError.value = 'Location permission denied';
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Location: ${position.latitude}, ${position.longitude}');

      final response = await _services.fetchNearbyBlinks(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      print('Nearby API status: ${response.statusCode}');
      print('Nearby API data: ${response.data}');

      final data = response.data['data'];
      final List blinkList = data['blinks'];
      blinks.value = blinkList
          .map((e) => NearbySafetyModel.fromJson(e))
          .toList();

      print('Blinks count: ${blinks.length}');
    } catch (e, stack) {
      print('NearbySafetyController Error: $e');
      print('StackTrace: $stack');
      locationError.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshFeed() async {
    blinks.clear();
    await fetchNearbyBlinks();
  }
}
