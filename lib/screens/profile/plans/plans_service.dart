import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';

import 'plans_model.dart';

class PlansService extends BaseApiService {
  // ─────────────────────────────────────────────
  // POST /plans
  // ─────────────────────────────────────────────

  Future<CreatePlanResponse> createPlan(CreatePlanRequest request) async {
    final token = await StoreServices.getAccessToken();

    final response = await post(
      "/plans",
      request.toJson(),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    // Structure:
    // { data: { id, status, message } }

    final body = response.data["data"] ?? response.data;

    return CreatePlanResponse.fromJson(body);
  }

  // ─────────────────────────────────────────────
  // GET /plans/upcoming
  // ─────────────────────────────────────────────

  Future<UpcomingPlansResponse> getUpcomingPlans() async {
    final token = await StoreServices.getAccessToken();

    final response = await get(
      "/plans/upcoming",
      headers: {"Authorization": "Bearer $token"},
    );

    return UpcomingPlansResponse.fromJson(response.data);
  }

  // ─────────────────────────────────────────────
  // GET /plans/upcoming/{id}
  // ─────────────────────────────────────────────

  Future<UpcomingPlanDetailsResponse> getUpcomingPlanById(String id) async {
    final token = await StoreServices.getAccessToken();

    final response = await get(
      "/plans/upcoming/$id",
      headers: {"Authorization": "Bearer $token"},
    );

    return UpcomingPlanDetailsResponse.fromJson(response.data);
  }

  // ─────────────────────────────────────────────
  // POST /plans/:id/items
  // ─────────────────────────────────────────────

  Future<AddPlanItemResponse> addPlanItem(
    String planId,
    AddPlanItemRequest request,
  ) async {
    final token = await StoreServices.getAccessToken();

    final response = await post(
      "/plans/$planId/items",
      request.toJson(),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final body = response.data["data"] ?? response.data;

    return AddPlanItemResponse.fromJson(body);
  }

  // GET /plans/saved-places
  Future<SavedPlacesResponse> getSavedPlaces() async {
    final token = await StoreServices.getAccessToken();

    final response = await get(
      "/plans/saved-places",
      headers: {"Authorization": "Bearer $token"},
    );

    return SavedPlacesResponse.fromJson(response.data);
  }
}
