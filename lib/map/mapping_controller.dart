import 'dart:async';
import 'dart:developer';

import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/map/blinx_map_controller.dart';
import 'package:blinx_mobile/map/blinx_map_style_install.dart';
import 'package:blinx_mobile/map/blinx_style_tokens.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MappingController extends GetxController {
  final _api = BaseApiService();

  // ── Map ──────────────────────────────────────────────────────────────
  MaplibreMapController? _mapController;

  bool _isMapReady = false;
  bool _styleReady = false;
  bool _isControllerAlive = true;

  bool _nearbyUsersSourceAdded = false;

  bool _sourceInstalled = false;
  bool _sourceInstalling = false;
  bool _pendingMarkerRefresh = false;
  bool isFirstLocationSet = false;

  // ── Pulse animation ───────────────────────────────────────────────────
  Timer? _pulseTimer;
  bool _pulsePhase = false;
  bool _myLocationInstalled = false;

  // ── Observables ───────────────────────────────────────────────────────
  final RxList<BlinxObject> nearbyBlinks = <BlinxObject>[].obs;
  final Rx<BlinxObject?> selectedBlink = Rx<BlinxObject?>(null);
  final RxList<BlinxObject> allBlinksCache = <BlinxObject>[].obs;

  final RxBool isLoadingNearby = false.obs;
  final RxBool isResolvingLocation = false.obs;
  final RxBool isLocationLoading = true.obs;

  final Rx<LatLng> centerLatLng = const LatLng(0, 0).obs;
  final RxString locationLabel = 'Finding location...'.obs;

  final Rx<String?> selectedTopicSlug = Rx<String?>(null);
  final RxList<BlinxTopic> availableTopics = <BlinxTopic>[].obs;

  // ── Lifecycle ─────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    log('🟡 [MC] onInit');

    ever(nearbyBlinks, (_) {
      log(
        '🟡 [MC] ever fired | mapReady=$_isMapReady | styleReady=$_styleReady | alive=$_isControllerAlive | blinks=${nearbyBlinks.length}',
      );
      if (_allGatesOpen) {
        _refreshMapMarkers();
      } else {
        _pendingMarkerRefresh = true;
        log('🟡 [MC] marked pending — gates not open yet');
      }
    });

    _startPulseAnimation();
  }

  @override
  void onClose() {
    _nearbyUsersSourceAdded = false;
    log('[MC] onClose');
    _isControllerAlive = false;
    _isMapReady = false;
    _styleReady = false;
    _sourceInstalled = false;
    _sourceInstalling = false;
    _myLocationInstalled = false;
    _pulseTimer?.cancel();
    _pulseTimer = null;
    try {
      _mapController?.onSymbolTapped.remove(_handleSymbolTap);
    } catch (_) {}
    _mapController = null;
    BlinxMapStyleInstaller.resetNearbyUsersSource();

    super.onClose();
  }

  bool get _allGatesOpen =>
      _isControllerAlive &&
      _isMapReady &&
      _styleReady &&
      _mapController != null;

  // ── Pulse animation ──────
  void _startPulseAnimation() {
    _pulseTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!_isControllerAlive) {
        timer.cancel();
        return;
      }
      if (!_allGatesOpen) return;
      if (!_myLocationInstalled) return; // wait until first install is done

      final lat = centerLatLng.value.latitude;
      final lng = centerLatLng.value.longitude;
      if (lat == 0 && lng == 0) return;

      _pulsePhase = !_pulsePhase;

      BlinxMapStyleInstaller.installMyLocationPin(
        controller: _mapController!,
        lat: lat,
        lng: lng,
        pulseRadius: _pulsePhase ? 28.0 : 16.0,
        pulseOpacity: _pulsePhase ? 0.12 : 0.30,
        isAlive: () => _allGatesOpen,
      );
    });
  }

  // ── Called from MapLibreMap.onMapCreated ────
  void setMapController(MaplibreMapController controller) {
    log('🟢 [MC] setMapController | alive=$_isControllerAlive');
    if (!_isControllerAlive) return;
    _mapController = controller;
    _isMapReady = true;
    _styleReady = false;
    _sourceInstalled = false;
    _sourceInstalling = false;
    _myLocationInstalled = false;
    controller.onSymbolTapped.add(_handleSymbolTap);
    log('🟢 [MC] mapReady=true — waiting for onStyleReady()');
    _fetchCurrentLocation();
  }

  // ── Called from MapLibreMap.onStyleLoadedCallback ──────
  void onStyleReady() {
    log(
      '🟢 [MC] onStyleReady | alive=$_isControllerAlive | blinks=${nearbyBlinks.length} | pending=$_pendingMarkerRefresh',
    );
    if (!_isControllerAlive) return;
    _styleReady = true;
    _sourceInstalled = false;
    _sourceInstalling = false;
    _myLocationInstalled = false;

    if (nearbyBlinks.isNotEmpty || _pendingMarkerRefresh) {
      _pendingMarkerRefresh = false;
      log('🟢 [MC] style ready + blinks exist → _refreshMapMarkers');
      _refreshMapMarkers();
    } else {
      log('🟢 [MC] style ready, no blinks yet');
      final lat = centerLatLng.value.latitude;
      final lng = centerLatLng.value.longitude;
      if (lat != 0 || lng != 0) {
        _updateMyLocationPin();
      }
    }
  }

  void _handleSymbolTap(Symbol symbol) {
    if (!_isControllerAlive) return;
    final id = symbol.data?['id']?.toString();
    if (id != null) selectBlink(id);
  }

  // ── Location ──────────
  Future<void> _fetchCurrentLocation() async {
    if (!_isControllerAlive) return;
    try {
      isLocationLoading.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (_isControllerAlive) locationLabel.value = 'Location disabled';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        if (_isControllerAlive) locationLabel.value = 'Permission denied';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!_isControllerAlive) return;

      final latLng = LatLng(position.latitude, position.longitude);
      if (latLng.latitude == 0 && latLng.longitude == 0) return;

      centerLatLng.value = latLng;

      await _resolveLocationName(latLng.latitude, latLng.longitude);
      if (!_isControllerAlive) return;

      if (_mapController != null && !isFirstLocationSet) {
        isFirstLocationSet = true;
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 14),
        );
      }
      if (!_isControllerAlive) return;

      // Show my location pin as soon as we have a position
      await _updateMyLocationPin();
      if (!_isControllerAlive) return;

      await fetchNearbyBlinks(around: latLng);
    } catch (e) {
      log('MappingController._fetchCurrentLocation error: $e');
      if (_isControllerAlive) locationLabel.value = 'Fetching location...';
    } finally {
      if (_isControllerAlive) isLocationLoading.value = false;
    }
  }

  Future<void> _resolveLocationName(double lat, double lng) async {
    if (!_isControllerAlive) return;
    try {
      isResolvingLocation.value = true;
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (!_isControllerAlive) return;
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final area = p.subLocality?.isNotEmpty == true
            ? p.subLocality!
            : p.locality?.isNotEmpty == true
            ? p.locality!
            : p.administrativeArea ?? '';
        locationLabel.value = area.isNotEmpty
            ? '$area, ${p.country ?? ""}'
            : (p.country ?? 'Unknown location');
      } else {
        locationLabel.value = 'Location not found';
      }
    } catch (e) {
      log('_resolveLocationName error: $e');
      if (_isControllerAlive) locationLabel.value = 'Fetching location...';
    } finally {
      if (_isControllerAlive) isResolvingLocation.value = false;
    }
  }

  Future<void> reCenterToMyLocation() async {
    if (!_isControllerAlive) return;
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!_isControllerAlive) return;

      final latLng = LatLng(position.latitude, position.longitude);
      centerLatLng.value = latLng;

      await _resolveLocationName(latLng.latitude, latLng.longitude);
      if (!_isControllerAlive) return;

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 14),
      );
      if (!_isControllerAlive) return;

      // Move my location pin to updated position
      await _updateMyLocationPin();
    } catch (e) {
      log('reCenterToMyLocation error: $e');
    }
  }

  Future<void> useThisArea() async {
    if (!_isControllerAlive || _mapController == null) return;
    final pos = _mapController!.cameraPosition;
    if (pos == null) return;
    final latLng = pos.target;
    centerLatLng.value = latLng;
    await _resolveLocationName(latLng.latitude, latLng.longitude);
    if (!_isControllerAlive) return;
    await fetchNearbyBlinks(around: latLng, topicSlug: selectedTopicSlug.value);
  }

  // ── API ──────────
  Future<void> fetchNearbyBlinks({
    LatLng? around,
    String? topicSlug,
    String? search,
  }) async {
    if (!_isControllerAlive) return;

    final lat = around?.latitude ?? centerLatLng.value.latitude;
    final lng = around?.longitude ?? centerLatLng.value.longitude;
    if (lat == 0 && lng == 0) {
      log('🟡 [MC] fetchNearbyBlinks skipped — location is (0,0)');
      return;
    }

    isLoadingNearby.value = true;
    try {
      final token = await StoreServices.getAccessToken();
      if (!_isControllerAlive) return;

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
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _api.get(
        'mobile/social/blinks/nearby?${_buildQuery(queryParams)}',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (!_isControllerAlive) return;

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List blinksJson = data['blinks'] ?? [];
        final blinks = blinksJson
            .map((e) => BlinxObject.fromJson(e as Map<String, dynamic>))
            .toList();

        nearbyBlinks.assignAll(blinks);
        allBlinksCache.assignAll(blinks);

        final topicMap = <String, BlinxTopic>{};
        for (final b in blinks) {
          if (b.topic != null && !topicMap.containsKey(b.topic!.slug)) {
            topicMap[b.topic!.slug] = b.topic!;
          }
        }
        availableTopics.assignAll(topicMap.values.toList());
        log('MappingController: fetched ${blinks.length} blinks');
      }
    } catch (e) {
      log('MappingController.fetchNearbyBlinks error: $e');
    } finally {
      if (_isControllerAlive) isLoadingNearby.value = false;
    }
  }

  Future<void> applyTopicFilter(String? slug) async {
    selectedTopicSlug.value = slug;

    final latLng = centerLatLng.value;

    await fetchNearbyBlinks(around: latLng, topicSlug: slug);
  }

  void selectBlink(String id) {
    if (!_isControllerAlive) return;
    final obj = nearbyBlinks.firstWhereOrNull((b) => b.id == id);
    if (obj != null) selectedBlink.value = obj;
  }

  void clearSelection() {
    if (_isControllerAlive) selectedBlink.value = null;
  }

  // ── Map markers ───────────────────────────────────────────────────────
  Future<void> _refreshMapMarkers() async {
    log(
      '[MC] _refreshMapMarkers | alive=$_isControllerAlive | mapReady=$_isMapReady | styleReady=$_styleReady | sourceInstalled=$_sourceInstalled | ctrl=${_mapController != null}',
    );

    if (!_allGatesOpen) {
      log('[MC] _refreshMapMarkers SKIPPED — gates not open');
      return;
    }

    final ctrl = _mapController!;

    try {
      log('[MC] clearSymbols...');
      await ctrl.clearSymbols();
      if (!_allGatesOpen) {
        log('[MC] died after clearSymbols');
        return;
      }

      // ── Blink pins ──────────────────────────────────────────────────
      if (_sourceInstalled) {
        log('[MC] sourceInstalled=true → setGeoJsonSource');
        await ctrl.setGeoJsonSource(
          BlinxMapTokens.blinxObjectSourceId,
          _buildGeoJson(nearbyBlinks.toList()),
        );
        log('[MC] setGeoJsonSource success');
      } else {
        if (_sourceInstalling) {
          log('🟡 [MC] installBlinxOverlay already in progress — skipping');
          return;
        }
        _sourceInstalling = true;
        log('🔵 [MC] sourceInstalled=false → installBlinxOverlay');
        try {
          final sourceBlinks = selectedTopicSlug.value == null
              ? allBlinksCache
              : nearbyBlinks;

          await BlinxMapStyleInstaller.installBlinxOverlay(
            controller: ctrl,
            objects: sourceBlinks.map((b) => b.toMapObject()).toList(),
            isAlive: () => _allGatesOpen,
          );
          if (_isControllerAlive) {
            _sourceInstalled = true;
            log('[MC] installBlinxOverlay success — sourceInstalled=true');
          }
        } finally {
          _sourceInstalling = false;
        }
      }

      // ── My location pin ─────────
      await _updateMyLocationPin();

      // ── Nearby users pins ────────
      await _updateNearbyUsersPins();
    } catch (e, st) {
      log('[MC] _refreshMapMarkers ERROR: $e');
      log('[MC] StackTrace: $st');
    }
  }

  // ── My Location pin ───────
  Future<void> _updateMyLocationPin() async {
    if (!_allGatesOpen) return;

    final lat = centerLatLng.value.latitude;
    final lng = centerLatLng.value.longitude;
    if (lat == 0 && lng == 0) return;

    _myLocationInstalled = true;
  }

  // ── Nearby users pins ─────────
  Future<void> _updateNearbyUsersPins() async {
    if (!_allGatesOpen) return;

    final sourceBlinks = selectedTopicSlug.value == null
        ? allBlinksCache
        : nearbyBlinks;

    final seen = <String>{};
    final users = <NearbyUserMapObject>[];

    for (final blink in sourceBlinks) {
      final author = blink.author;
      if (author == null) continue;
      if (!seen.add(author.id)) continue;

      final obj = blink.toMapObject();

      users.add(
        NearbyUserMapObject(
          id: author.id,
          lat: obj.lat,
          lng: obj.lng,
          name: author.name ?? 'User',
          color: NearbyUserMapObject.colorForId(author.id),
        ),
      );
    }

    if (users.isEmpty) return;

    await BlinxMapStyleInstaller.installNearbyUsersPins(
      controller: _mapController!,
      users: users,
      sourceAdded: _nearbyUsersSourceAdded,
      onSourceAdded: (val) => _nearbyUsersSourceAdded = val,
      isAlive: () => _allGatesOpen,
    );
  }

  // ── GeoJSON builder ────────────
  Map<String, dynamic> _buildGeoJson(List<BlinxObject> blinks) {
    return {
      'type': 'FeatureCollection',
      'features': blinks.map((b) {
        final obj = b.toMapObject();
        return {
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [obj.lng, obj.lat],
          },
          'properties': {
            'id': obj.id,
            'name': obj.name,
            if (obj.category != null) 'category': obj.category,
            ...obj.extraProperties,
          },
        };
      }).toList(),
    };
  }

  String _buildQuery(Map<String, dynamic> params) {
    return params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }
}
