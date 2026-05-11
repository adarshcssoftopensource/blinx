import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/social_pulse_screen/draft_details_screen/model/draft_details_model.dart';
import 'package:blinx_mobile/social_pulse_screen/draft_details_screen/services/draft_details_services.dart';
import 'package:get/get.dart';

class DraftDetailsController extends GetxController {
  final DraftDetailsServices _services = DraftDetailsServices();

  final RxBool isPublishing = false.obs;
  final RxBool isSuccess = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<DraftDetailsModel> publishedBlink = Rxn<DraftDetailsModel>();

  Future<void> publishDraft(String draftId) async {
    try {
      isPublishing(true);
      isSuccess(false);
      errorMessage('');

      final token = await StoreServices.getAccessToken() ?? '';

      final result = await _services.publishDraft(
        draftId: draftId,
        token: token,
      );

      publishedBlink.value = result;
      isSuccess(true);
    } catch (e) {
      errorMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isPublishing(false);
    }
  }
}
