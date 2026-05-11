import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/saved_places/saved_place_model.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/saved_places/saved_places_service.dart';
import 'package:get/get.dart';

class SavedPlacesController extends GetxController {
  final SavedPlacesService _service = SavedPlacesService();

  final RxList<SavedPlaceModel> savedPlaces = <SavedPlaceModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavedPlaces();
  }

  Future<void> fetchSavedPlaces() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.getSavedPlaces();

      if (response.success && response.data != null) {
        savedPlaces.assignAll(response.data!);
      } else {
        errorMessage.value = response.message;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
