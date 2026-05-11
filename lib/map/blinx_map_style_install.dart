import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:maplibre_gl/maplibre_gl.dart';

import 'blinx_style_tokens.dart';

class BlinxMapStyleInstaller {
  BlinxMapStyleInstaller._();

  static bool _nearbyUsersSourceAdded = false;

  static void resetNearbyUsersSource() {
    _nearbyUsersSourceAdded = false;
  }

  // ── PUBLIC API ────

  static Future<String> resolvedStyleString() async {
    final raw = await _loadRawStyle();
    return _injectKey(raw, BlinxMapTokens.mapTilerKey);
  }

  static Future<Map<String, dynamic>> resolvedStyleMap() async {
    final str = await resolvedStyleString();
    return json.decode(str) as Map<String, dynamic>;
  }

  // ── BLINK OVERLAY ─────

  static Future<void> installBlinxOverlay({
    required dynamic controller,
    required List<BlinxMapObject> objects,
    bool Function()? isAlive,
  }) async {
    bool alive() => isAlive == null || isAlive();
    if (!alive()) return;

    await controller.clearSymbols();

    for (final obj in objects) {
      try {
        await controller.addSymbol(
          SymbolOptions(
            geometry: LatLng(obj.lat, obj.lng),
            iconSize: 0.1,
            textField: '',
          ),
          {
            "id": obj.id,
            "topicColor": obj.topicColor ?? '#FF5A1F',
            ...obj.extraProperties,
          },
        );
      } catch (_) {}
    }
  }

  // ── UPDATE BLINKS ───────

  static Future<void> updateBlinxObjects({
    required dynamic controller,
    required List<BlinxMapObject> objects,
    bool Function()? isAlive,
  }) async {
    bool alive() => isAlive == null || isAlive();
    if (!alive()) return;

    try {
      await controller.clearSymbols();

      for (final obj in objects) {
        await controller.addSymbol(
          SymbolOptions(
            geometry: LatLng(obj.lat, obj.lng),
            iconSize: 0.1,
            textField: '',
          ),
          {
            "id": obj.id,
            "topicColor": obj.topicColor ?? '#FF5A1F',
            ...obj.extraProperties,
          },
        );
      }
    } catch (_) {
      if (!alive()) return;
      await installBlinxOverlay(
        controller: controller,
        objects: objects,
        isAlive: isAlive,
      );
    }
  }

  // ── MY LOCATION PIN ──────

  static Future<void> installMyLocationPin({
    required dynamic controller,
    required double lat,
    required double lng,
    double pulseRadius = 22.0,
    double pulseOpacity = 0.25,
    bool Function()? isAlive,
  }) async {
    bool alive() => isAlive == null || isAlive();
    if (!alive()) return;

    final sourceId = BlinxMapTokens.myLocationSourceId;

    final geoJson = {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [lng, lat],
          },
          'properties': {},
        },
      ],
    };

    try {
      await controller.setGeoJsonSource(sourceId, geoJson);
    } catch (_) {
      await controller.addSource(
        sourceId,
        GeojsonSourceProperties(data: geoJson),
      );
    }

    if (!alive()) return;

    await _safeRemoveLayer(controller, BlinxMapTokens.myLocationPulseLayerId);
    await _safeRemoveLayer(controller, BlinxMapTokens.myLocationDotLayerId);

    if (!alive()) return;

    await controller.addCircleLayer(
      sourceId,
      BlinxMapTokens.myLocationPulseLayerId,
      CircleLayerProperties(
        circleRadius: pulseRadius,
        circleColor: '#FF3B30',
        circleOpacity: pulseOpacity,
      ),
    );

    if (!alive()) return;

    await controller.addCircleLayer(
      sourceId,
      BlinxMapTokens.myLocationDotLayerId,
      CircleLayerProperties(
        circleRadius: 8,
        circleColor: '#2A73EA',
        circleStrokeWidth: 2,
        circleStrokeColor: '#FFFFFF',
      ),
    );
  }

  static Future<void> installNearbyUsersPins({
    required dynamic controller,
    required List<NearbyUserMapObject> users,
    required bool sourceAdded, // ← ADD
    required void Function(bool) onSourceAdded, // ← ADD
    bool Function()? isAlive,
  }) async {
    bool alive() => isAlive == null || isAlive();
    if (!alive()) return;

    final sourceId = BlinxMapTokens.nearbyUsersSourceId;

    final geoJson = {
      'type': 'FeatureCollection',
      'features': users
          .map(
            (u) => {
              'type': 'Feature',
              'geometry': {
                'type': 'Point',
                'coordinates': [u.lng, u.lat],
              },
              'properties': {'id': u.id, 'name': u.name, 'color': u.color},
            },
          )
          .toList(),
    };

    if (sourceAdded) {
      try {
        await controller.setGeoJsonSource(sourceId, geoJson);
      } catch (_) {
        onSourceAdded(false);
      }
    }

    if (!sourceAdded) {
      try {
        await controller.addSource(
          sourceId,
          GeojsonSourceProperties(data: geoJson),
        );
        onSourceAdded(true);
      } catch (_) {
        try {
          await controller.setGeoJsonSource(sourceId, geoJson);
          onSourceAdded(true);
        } catch (_) {
          return;
        }
      }
    }

    if (!alive()) return;

    await _safeRemoveLayer(controller, BlinxMapTokens.nearbyUsersLabelLayerId);
    await _safeRemoveLayer(controller, BlinxMapTokens.nearbyUsersLayerId);

    if (!alive()) return;

    await controller.addCircleLayer(
      sourceId,
      BlinxMapTokens.nearbyUsersLayerId,
      CircleLayerProperties(
        circleRadius: 20,
        circleColor: ['get', 'color'],
        circleStrokeWidth: 2,
        circleStrokeColor: '#FFFFFF',
      ),
    );

    if (!alive()) return;

    await controller.addSymbolLayer(
      sourceId,
      BlinxMapTokens.nearbyUsersLabelLayerId,
      SymbolLayerProperties(
        textField: ['get', 'name'],
        textSize: 10,
        textColor: '#FFFFFF',
        textMaxWidth: 5,
        textAllowOverlap: true,
        textIgnorePlacement: true,
        textAnchor: 'center',
        textJustify: 'center',
        textHaloColor: '#000000',
        textHaloWidth: 1.2,
        textFont: [
          'literal',
          ['Noto Sans Regular'],
        ],
      ),
    );
  }

  // ── CAMERA ────
  static Future<void> flyToObject({
    required dynamic controller,
    required BlinxMapObject object,
    double zoom = 16.0,
  }) async {
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(object.lat, object.lng), zoom),
      duration: BlinxMapTokens.cameraAnimDuration,
    );
  }

  // ── HELPERS ──────
  static Future<String> _loadRawStyle() async {
    return rootBundle.loadString(BlinxMapTokens.localStyleAssetPath);
  }

  static String _injectKey(String raw, String key) {
    return raw.replaceAll('__MAPTILER_KEY__', key);
  }

  static Future<void> _safeRemoveLayer(dynamic ctrl, String id) async {
    try {
      await ctrl.removeLayer(id);
    } catch (_) {}
  }
}

// ── MODELS ──────────
class BlinxMapObject {
  const BlinxMapObject({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    this.category,
    this.topicColor,
    this.extraProperties = const {},
  });

  final String id;
  final String name;
  final double lat;
  final double lng;
  final String? category;
  final String? topicColor;
  final Map<String, dynamic> extraProperties;
}

class NearbyUserMapObject {
  final String id;
  final double lat;
  final double lng;
  final String name;
  final String color;

  NearbyUserMapObject({
    required this.id,
    required this.lat,
    required this.lng,
    required this.name,
    required this.color,
  });

  static String colorForId(String id) {
    const colors = ['#E53935', '#8E24AA', '#1E88E5', '#43A047', '#FB8C00'];
    return colors[id.hashCode % colors.length];
  }
}
