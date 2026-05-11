import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:get/get.dart';

import '../model/draft_model.dart';
import '../services/draft_services.dart';

class DraftController extends GetxController {
  final DraftServices _draftServices = DraftServices();

  final RxList<DraftModel> drafts = <DraftModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDrafts();
  }

  Future<void> fetchDrafts() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = await StoreServices.getAccessToken() ?? '';

      final result = await _draftServices.fetchDrafts(token: token);
      drafts.assignAll(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void toggleLike(int index) {
    drafts[index].isLiked = !drafts[index].isLiked;
    drafts.refresh();
  }

  String formatTime(DateTime createdAt) {
    final Duration diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    if (diff.inDays < 7) return "${diff.inDays}d ago";
    return "${(diff.inDays / 7).floor()}w ago";
  }
}
