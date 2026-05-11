import 'package:blinx_mobile/steward_screen/marketplace_list/view/marketplace_list_screen.dart';
import 'package:blinx_mobile/utils/screens/snackbar_helper.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/marketplace_detail_model.dart';
import '../services/marketplace_detail_services.dart';

// Controller responsible for handling Steward Marketplace Detail screen logic
class StewardMarketplaceDetailController extends GetxController {
  // Service layer instance for API calls
  final MarketplaceDetailServices marketplaceDetailServices =
      MarketplaceDetailServices();

  // Observable to store marketplace detail response data
  Rx<ApplicationDetailResponse?> marketPlaceData =
      Rx<ApplicationDetailResponse?>(null);

  // Loading state observable for UI
  var isLoading = false.obs;

  Future<void> getMarketPlaceDetailApi({String? applicationId}) async {
    isLoading.value = true;
    try {
      // Call detail API services
      var response = await marketplaceDetailServices
          .getMarketPlaceApplicationDetailService(id: applicationId);
      print(response.data);
      if (response.success) {
        // Update observable data on success
        marketPlaceData.value = response.data;
        print(response.message);
      } else {
        // Show error snackbar if API fails
        AppSnackbar.show(
          title: AppConstants.failed,
          message: response.message ?? AppConstants.somethingWentWrong,
          isSuccess: false,
        );
      }
    } catch (e, stace) {
      // Handle unexpected errors
      print("Error: $stace");
      Get.snackbar(AppConstants.failed, e.toString());
    } finally {
      // Stop loader
      isLoading.value = false;
    }
  }

  // Accept submitted application
  Future<void> acceptApplicationApi({
    required String applicationId,
    Map<String, dynamic> postData = const {},
  }) async {
    isLoading.value = true;

    try {
      // Call accept API services
      final response = await marketplaceDetailServices.acceptApplicationService(
        postData,
        id: applicationId,
      );
      print("DATA => ${response.data}");
      print("MSG => ${response.message}");
      if (response.success) {
        // Show success message and navigate back to list
        AppSnackbar.show(
          title: AppConstants.success,
          message: response.message ?? AppConstants.applicationApproved,
          isSuccess: true,
        );
        Get.off(() => const MarketplaceListScreen());
      } else {
        // Show failure message
        Get.snackbar(
          AppConstants.failed,
          response.message ?? AppConstants.somethingWentWrong,
        );
      }
    } catch (e, stack) {
      // Handle API exception
      print("Accept Error => $e");
      Get.snackbar(AppConstants.failed, e.toString());
    } finally {
      // Stop loader
      isLoading.value = false;
    }
  }

  // Reject submitted application with reason
  Future<void> rejectApplicationApi({
    required String applicationId,
    required Map<String, dynamic> postData,
  }) async {
    isLoading.value = true;

    try {
      // Call reject API services
      final response = await marketplaceDetailServices.rejectApplicationService(
        postData,
        id: applicationId,
      );

      if (response.success) {
        // Show success message and navigate back to list
        AppSnackbar.show(
          title: AppConstants.success,
          message: response.message ?? AppConstants.applicationRejected,
          isSuccess: true,
        );
        Get.off(() => const MarketplaceListScreen());
      } else {
        // Show failure message
        AppSnackbar.show(
          title: AppConstants.failed,
          message: response.message ?? AppConstants.somethingWentWrong,
          isSuccess: false,
        );
      }
    } catch (e, stack) {
      // Handle API exception
      print("Reject Error => $e");
      debugPrintStack(stackTrace: stack);
      Get.snackbar(AppConstants.failed, e.toString());
    } finally {
      // Stop loader
      isLoading.value = false;
    }
  }
}
