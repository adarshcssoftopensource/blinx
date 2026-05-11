import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/social_pulse_screen/topic_feed_screen/model/topic_feed_model.dart';
import 'package:get/get.dart';

class TopicFeedController extends GetxController {
  final String topicId;
  TopicFeedController({required this.topicId});

  final BaseApiService _apiService = BaseApiService();

  var blinks = <TopicFeedModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var topicName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopicFeed();
  }

  Future<void> fetchTopicFeed() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      print('CALLING URL: mobile/social/blinks/topic/$topicId');
      final token = await StoreServices.getAccessToken();

      final response = await _apiService.get(
        'mobile/social/blinks/topic/$topicId',
        headers: {'Authorization': 'Bearer $token'},
      );

      print('FULL RESPONSE: ${response.data}');

      final data = response.data['data'];
      topicName.value = data['topic']['name'];

      final List blinkList = data['blinks'];
      blinks.value = blinkList.map((e) => TopicFeedModel.fromJson(e)).toList();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshFeed() async {
    blinks.clear();
    await fetchTopicFeed();
  }
}
