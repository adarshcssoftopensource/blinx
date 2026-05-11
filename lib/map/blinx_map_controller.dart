import 'dart:developer';

import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'blinx_map_style_install.dart';

class BlinxTopic {
  final String id;
  final String name;
  final String slug;
  final String color;
  final String icon;

  const BlinxTopic({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.icon,
  });

  factory BlinxTopic.fromJson(Map<String, dynamic> json) {
    return BlinxTopic(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      color: json['color'] ?? '#E8F1FF',
      icon: json['icon'] ?? '',
    );
  }
}

// MODEL — Author
class BlinxAuthor {
  final String id;
  final String name;
  final String? profileImage;
  final bool isVerified;

  const BlinxAuthor({
    required this.id,
    required this.name,
    this.profileImage,
    required this.isVerified,
  });

  factory BlinxAuthor.fromJson(Map<String, dynamic> json) {
    return BlinxAuthor(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      isVerified: json['isVerified'] == true,
    );
  }
}

// MODEL — BlinxObject (Blink)
class BlinxObject {
  final String id;
  final String content;
  final String? imageUrl;
  final double lat;
  final double lng;
  final String locationName;
  final double distanceKm;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final String createdAt;
  final bool isLikedByMe;
  final BlinxTopic? topic;
  final BlinxAuthor? author;

  const BlinxObject({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.lat,
    required this.lng,
    required this.locationName,
    required this.distanceKm,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.createdAt,
    required this.isLikedByMe,
    this.topic,
    this.author,
  });

  factory BlinxObject.fromJson(Map<String, dynamic> json) {
    return BlinxObject(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      lat: (json['latitude'] ?? 0).toDouble(),
      lng: (json['longitude'] ?? 0).toDouble(),
      locationName: json['locationName'] ?? '',
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      isLikedByMe: json['isLikedByMe'] == true,
      topic: json['topic'] != null ? BlinxTopic.fromJson(json['topic']) : null,
      author: json['author'] != null
          ? BlinxAuthor.fromJson(json['author'])
          : null,
    );
  }

  // Map marker object
  BlinxMapObject toMapObject() => BlinxMapObject(
    id: id,
    name: author?.name ?? '',
    lat: lat,
    lng: lng,
    category: topic?.slug,
    extraProperties: {
      'topicColor': topic?.color ?? '#FF5A1F',
      'imageUrl': imageUrl ?? '',
      'topicName': topic?.name ?? '',
    },
  );

  // Distance label
  String get distanceLabel {
    if (distanceKm == 0) return 'Here';
    if (distanceKm < 1) return '${(distanceKm * 1000).toInt()} m away';
    return '${distanceKm.toStringAsFixed(1)} km away';
  }

  // Time ago label
  String get timeAgoLabel {
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
  }
}

// controller
class BlinxMapController extends GetxController {
  MaplibreMapController? mapController;

  bool isFirstLocationSet = false;

  final _api = BaseApiService();

  // State
  final RxList<BlinxObject> nearbyObjects = <BlinxObject>[].obs;
  final Rx<BlinxObject?> selectedObject = Rx<BlinxObject?>(null);

  final RxBool isLoadingNearby = false.obs;
  final RxBool isSheetOpen = false.obs;
  final RxBool isResolvingLocation = false.obs;

  final Rx<LatLng> centerLatLng = const LatLng(0, 0).obs;
  final RxString locationLabel = 'Finding location...'.obs;
  final RxBool isLocationLoading = true.obs;

  // Filter — selected topic slug (null = All)
  final Rx<String?> selectedTopicSlug = Rx<String?>(null);

  // All topics discovered from API
  final RxList<BlinxTopic> availableTopics = <BlinxTopic>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(nearbyObjects, (_) async {
      await refreshMapMarkers();
    });
  }

  // ── Map controller setup ──────────────────
  void setMapController(MaplibreMapController controller) {
    mapController = controller;
    controller.clearSymbols();
    controller.onSymbolTapped.add(_handleSymbolTap);
    getCurrentLocation();
  }

  void _handleSymbolTap(Symbol symbol) {
    final objectId = symbol.data?['id']?.toString();
    if (objectId != null) onMarkerTapped(objectId);
  }

  void onMarkerTapped(String objectId) {
    final obj = nearbyObjects.firstWhereOrNull((o) => o.id == objectId);

    if (obj != null) {
      selectedObject.value = obj;
      isSheetOpen.value = true;
    }
  }

  // ── Location ─────────────────────────────
  Future<void> getCurrentLocation() async {
    try {
      isLocationLoading.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      if (latLng.latitude == 0 && latLng.longitude == 0) return;

      centerLatLng.value = latLng;

      if (mapController != null && !isFirstLocationSet) {
        isFirstLocationSet = true;
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 14),
        );
      }

      await fetchNearbyObjects(around: latLng);
    } catch (e) {
      log("getCurrentLocation error: $e");
    } finally {
      isLocationLoading.value = false;
    }
  }

  // ── Fetch Nearby Blinks from real API ────
  Future<void> fetchNearbyObjects({LatLng? around, String? topicSlug}) async {
    isLoadingNearby.value = true;

    try {
      final lat = around?.latitude ?? centerLatLng.value.latitude;
      final lng = around?.longitude ?? centerLatLng.value.longitude;

      final token = await StoreServices.getAccessToken();

      final queryParams = <String, dynamic>{
        'latitude': lat,
        'longitude': lng,
        'radiusKm': 10,
        'limit': 50,
        'page': 1,
      };

      if (topicSlug != null && topicSlug.isNotEmpty) {
        queryParams['topic'] = topicSlug;
      }

      final endpoint =
          'mobile/social/blinks/nearby?${_buildQuery(queryParams)}';

      final response = await _api.get(
        endpoint,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List blinksJson = data['blinks'] ?? [];

        final blinks = blinksJson
            .map((e) => BlinxObject.fromJson(e as Map<String, dynamic>))
            .toList();

        nearbyObjects.assignAll(blinks);

        // Collect unique topics from response
        final topicMap = <String, BlinxTopic>{};
        for (final b in blinks) {
          if (b.topic != null && !topicMap.containsKey(b.topic!.slug)) {
            topicMap[b.topic!.slug] = b.topic!;
          }
        }
        availableTopics.assignAll(topicMap.values.toList());

        log("Fetched ${blinks.length} nearby blinks");
      }
    } catch (e) {
      log("fetchNearbyObjects error: $e");
    } finally {
      isLoadingNearby.value = false;
    }
  }

  // ── Topic filter ─────────────────────────
  Future<void> applyTopicFilter(String? slug) async {
    selectedTopicSlug.value = slug;
    await fetchNearbyObjects(around: centerLatLng.value, topicSlug: slug);
  }

  Future<void> refreshMapMarkers() async {
    if (mapController == null) return;

    try {
      await BlinxMapStyleInstaller.updateBlinxObjects(
        controller: mapController!,
        objects: nearbyObjects.map((e) => e.toMapObject()).toList(),
      );
    } catch (e) {
      log("refreshMapMarkers error: $e");
    }
  }

  void closeSheet() {
    isSheetOpen.value = false;
    selectedObject.value = null;
  }

  void openObjectFromFeed(BlinxObject obj) {
    selectedObject.value = obj;
    isSheetOpen.value = true;
  }

  // ── Helpers ──────────────────────────────
  String _buildQuery(Map<String, dynamic> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }

  @override
  void onClose() {
    if (mapController != null) {
      mapController!.onSymbolTapped.remove(_handleSymbolTap);
      mapController!.dispose();
    }
    super.onClose();
  }
}
