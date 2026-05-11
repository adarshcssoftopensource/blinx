import 'package:get/get.dart';

import '../plans_model.dart';
import '../plans_service.dart';

class PlansController extends GetxController {
  final PlansService _service = PlansService();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingUpcoming = false.obs;
  final RxBool isAddingItem = false.obs;
  final RxBool isLoadingSavedPlaces = false.obs;

  // PlansController
  final RxList<SavedPlace> selectedPlaces = <SavedPlace>[].obs;
  final RxBool isSaving = false.obs;

  final RxString errorMessage = ''.obs;
  final RxString createdPlanId = ''.obs;

  final RxList<UpcomingPlan> upcomingPlans = <UpcomingPlan>[].obs;

  final RxList<Map<String, String>> planItems = <Map<String, String>>[].obs;

  final RxList<SavedPlace> savedPlaces = <SavedPlace>[].obs;

  // ─────────────────────────────────────────────
  // Single Plan Details
  // ─────────────────────────────────────────────

  final Rx<UpcomingPlanDetails?> upcomingPlanDetails = Rx<UpcomingPlanDetails?>(
    null,
  );

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingPlans();
  }

  // GET /plans/upcoming

  Future<void> fetchUpcomingPlans() async {
    isLoadingUpcoming.value = true;
    errorMessage.value = '';

    try {
      final response = await _service.getUpcomingPlans();

      if (response.status) {
        for (var plan in response.data) {}
        final sorted = List.of(response.data)
          // ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          ..sort((a, b) => b.id.compareTo(a.id));
        upcomingPlans.assignAll(sorted);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = "Failed to load plans.";
    } finally {
      isLoadingUpcoming.value = false;
    }
  }

  Future<void> fetchUpcomingPlanById(String id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _service.getUpcomingPlanById(id);

      if (response.status) {
        upcomingPlanDetails.value = response.data;
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = "Failed to load plan details.";
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // POST /plans
  // ─────────────────────────────────────────────

  Future<bool> createPlan({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    String status = "UPCOMING",
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final request = CreatePlanRequest(
        title: title,
        description: description,
        startDate: startDate.toIso8601String(),
        endDate: endDate.toIso8601String(),
        status: status,
      );

      final response = await _service.createPlan(request);

      if (response.status) {
        createdPlanId.value = response.data.id;

        // await fetchUpcomingPlans();

        // final newPlan = upcomingPlans.firstWhereOrNull(
        //   (p) => p.id == response.data.id,
        // );
        // if (newPlan != null) {
        //   upcomingPlans.remove(newPlan);
        //   upcomingPlans.insert(0, newPlan);
        // }
        await fetchUpcomingPlans();

        return true;
      } else {
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : "Plan creation failed.";

        return false;
      }
    } catch (e) {
      errorMessage.value = "Something went wrong. Please try again.";

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // POST /plans/:id/items
  // ─────────────────────────────────────────────

  Future<bool> addPlanItem({
    required String planId,
    required String externalId,
    required String type,
    required String name,
    required String locationName,
    required String thumbnailUrl,
  }) async {
    isAddingItem.value = true;
    errorMessage.value = '';

    try {
      final request = AddPlanItemRequest(externalIds: [externalId]);

      final response = await _service.addPlanItem(planId, request);

      if (response.status) {
        planItems.add({
          "name": name,
          "locationName": locationName,
          "thumbnailUrl": thumbnailUrl,
          "externalId": externalId,
          "nextActionCue": response.nextActionCue,
        });

        return true;
      } else {
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : "Failed to add place.";

        return false;
      }
    } catch (e) {
      errorMessage.value = "Failed to add place.";

      return false;
    } finally {
      isAddingItem.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // GET /plans/saved-places
  // ─────────────────────────────────────────────

  Future<void> fetchSavedPlaces() async {
    isLoadingSavedPlaces.value = true;
    errorMessage.value = '';

    try {
      final response = await _service.getSavedPlaces();

      if (response.status) {
        savedPlaces.assignAll(response.data);
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = "Failed to load saved places.";
    } finally {
      isLoadingSavedPlaces.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // Clear Plan Details
  // ─────────────────────────────────────────────

  void clearPlanDetails() {
    upcomingPlanDetails.value = null;
  }
}
