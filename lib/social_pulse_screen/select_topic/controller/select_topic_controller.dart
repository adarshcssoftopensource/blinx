import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:get/get.dart';

import '../model/select_topic_model.dart';
import '../services/select_topic_services.dart';

class SelectTopicController extends GetxController {
  final SelectTopicServices services = SelectTopicServices();

  final isLoading = false.obs;
  final topics = <SelectTopicModel>[].obs;
  final selectedTopic = Rxn<SelectTopicModel>();
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    try {
      isLoading.value = true;

      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) throw "No access token found";

      final response = await services.getTopics(token: token);

      if (response.success) {
        topics.assignAll(response.topics);
      } else {
        Get.snackbar("Failed", response.message ?? "Failed to load topics");
      }
    } catch (e) {
      Get.snackbar("Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectTopic(SelectTopicModel topic) {
    selectedTopic.value = topic;
  }
}
