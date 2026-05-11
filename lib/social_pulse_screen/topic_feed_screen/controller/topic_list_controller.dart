import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/social_pulse_screen/topic_feed_screen/model/topic_model.dart';
import 'package:get/get.dart';

class TopicListController extends GetxController {
  final BaseApiService _apiService = BaseApiService();

  var topics = <TopicModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    try {
      isLoading.value = true;
      final token = await StoreServices.getAccessToken();

      final response = await _apiService.get(
        'mobile/social/topics',
        headers: {'Authorization': 'Bearer $token'},
      );

      print('TOPICS RESPONSE: ${response.data}');
      final data = response.data['data'];
      final List list = data['topics'] ?? data['items'] ?? data['list'] ?? [];
      topics.value = list.map((e) => TopicModel.fromJson(e)).toList();
    } catch (e) {
      print('TopicListController Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
