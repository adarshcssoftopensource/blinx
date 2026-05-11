import 'dart:io';

import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/authentication/controller/auth_controller.dart';
import 'package:blinx_mobile/screens/profile/services/profile_screen_services.dart';
// import 'package:blinx_mobile/screens/profile/profile_screen_controller.dart';
import 'package:blinx_mobile/social_pulse_screen/select_topic/model/select_topic_model.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_geocoding/flutter_geocoding.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../model/create_post_private_model.dart';
import '../services/create_post_private_services.dart';

class CreatePostPrivateController extends GetxController {
  final CreatePostPrivateServices services = CreatePostPrivateServices();

  final userName = ''.obs;
  final userAvatar = ''.obs;

  final isDraftLoading = false.obs;
  final isPublishLoading = false.obs;
  final isSuccess = false.obs;
  final isDraftSuccess = false.obs;
  final createdBlink = Rxn<CreatePostPrivateModel>();

  final selectedTopic = Rxn<SelectTopicModel>();
  final locationName = ''.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

  void _showSnackbar(String title, String message, Color bgColor) {
    Future.microtask(() {
      Get.snackbar(
        title,
        message,
        backgroundColor: bgColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    });
  }

  @override
  void onInit() {
    super.onInit();

    final data = Get.arguments;
    if (data != null && data is SelectTopicModel) {
      selectedTopic.value = data;
      print("Received Topic: ${data.name}");
    } else {
      print("No topic received");
    }

    _loadUserInfo();
    _loadCurrentLocation();
  }

  Future<void> _loadUserInfo() async {
    final image = await StoreServices.getProfileImage();
    userAvatar.value = image ?? '';

    final authName = AuthController.to.userName.value;
    if (authName.isNotEmpty) {
      userName.value = authName;
      print("👤 NAME => '${userName.value}'");
      return;
    }

    try {
      final token = await StoreServices.getAccessToken();
      if (token != null && token.isNotEmpty) {
        final ProfileService profileService = ProfileService();
        final response = await profileService.getMyProfileService();
        if (response.success && response.data != null) {
          final name = response.data!.data.user.name ?? '';
          userName.value = name;
          await StoreServices.saveUserName(name);
          AuthController.to.userName.value = name;
        }
      }
    } catch (e) {
      print("Name fetch error: $e");
    }

    print("👤 NAME => '${userName.value}'");
    print("🖼 IMAGE => ${userAvatar.value}");
  }

  Future<void> _loadCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        locationName.value = 'Location not available';
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          // final city = place.locality ?? place.subAdministrativeArea ?? '';
          // final country = place.country ?? '';
          final city = place.subLocality?.isNotEmpty == true
              ? place.subLocality!
              : place.locality?.isNotEmpty == true
              ? place.locality!
              : place.subAdministrativeArea ?? place.administrativeArea ?? '';
          final country = place.country ?? '';
          print(
            "PLACEMARK => locality: ${place.locality}, subAdmin: ${place.subAdministrativeArea}, admin: ${place.administrativeArea}, country: ${place.country}",
          );
          print(" FINAL CITY => $city, $country");
          locationName.value = city.isNotEmpty ? "$city, $country" : country;
        }
      } catch (e) {
        locationName.value =
            "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
      }
      print(" Live Location => ${locationName.value}");
    } catch (e) {
      print("Location Error: $e");
      locationName.value = 'Location not available';
    }
  }

  Future<void> createPrivateBlink({
    required String content,
    required String topicId,
    required String locationName,
    required double latitude,
    required double longitude,
    File? image,
  }) async {
    await _createBlink(
      content: content,
      topicId: topicId,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      image: image,
      status: 'active',
    );
  }

  Future<void> saveAsDraft({
    required String content,
    required String topicId,
    required String locationName,
    required double latitude,
    required double longitude,
    File? image,
  }) async {
    await _createBlink(
      content: content,
      topicId: topicId,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      image: image,
      status: 'draft',
    );
  }

  Future<void> _createBlink({
    required String content,
    required String topicId,
    required String locationName,
    required double latitude,
    required double longitude,
    File? image,
    required String status,
  }) async {
    if (isDraftLoading.value || isPublishLoading.value) return;

    try {
      if (status == 'draft') {
        isDraftLoading.value = true;
      } else {
        isPublishLoading.value = true;
      }
      isSuccess.value = false;
      isDraftSuccess.value = false;

      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) {
        throw "No access token found";
      }

      print("Create Private Blink API HIT");
      print("Content: $content");
      print("Status: $status");

      final finalTopicId = topicId.isNotEmpty
          ? topicId
          : selectedTopic.value?.id ?? "";

      print("Topic ID: $finalTopicId");
      print("Location: $locationName");

      final response = await services.createPrivateBlink(
        token: token,
        content: content,
        topicId: finalTopicId,
        locationName: locationName,
        latitude: latitude,
        longitude: longitude,
        image: image,
        status: status,
      );

      print("Raw Response: ${response.data}");

      if (response.success && response.data != null) {
        final blinkJson = response.data!['blink'];
        if (blinkJson != null) {
          createdBlink.value = CreatePostPrivateModel.fromJson(blinkJson);
          print("Private Blink Created: ${createdBlink.value?.id}");
        }

        if (status == 'draft') {
          isDraftSuccess.value = true;
          _showSnackbar("Saved", "Draft saved successfully!", Colors.green);
        } else {
          isSuccess.value = true;
          _showSnackbar(
            "Success",
            "Private Blink published successfully!",
            Colors.green,
          );
        }
      } else {
        _showSnackbar(
          "Failed",
          response.message ?? "Do not exceed 500 characters",
          Colors.red,
        );
      }
    } catch (e) {
      print("Create Private Blink Error: $e");
      _showSnackbar("Error", e.toString(), Colors.red);
    } finally {
      isDraftLoading.value = false;
      isPublishLoading.value = false;
    }
  }
}
