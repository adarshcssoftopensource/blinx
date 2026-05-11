import 'package:blinx_mobile/map/blinx_map_controller.dart';
import 'package:blinx_mobile/map/blinx_map_style_install.dart';
import 'package:blinx_mobile/map/blinx_style_tokens.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:permission_handler/permission_handler.dart';

class BlinxMapScreen extends StatelessWidget {
  final Function(LatLng latLng, String locationName)? onLocationPicked;
  final bool readOnly;
  final LatLng? initialLocation;
  final String? initialLocationName;

  BlinxMapScreen({
    super.key,
    this.onLocationPicked,
    this.readOnly = false,
    this.initialLocation,
    this.initialLocationName,
  }) {
    _init();
  }

  final BlinxMapController _ctrl = Get.put(
    BlinxMapController(),
    permanent: false,
  );

  final RxnString _resolvedStyle = RxnString();

  Future<void> _init() async {
    await Permission.location.request();

    final style = await BlinxMapStyleInstaller.resolvedStyleString();
    _resolvedStyle.value = style;

    if (readOnly && initialLocation != null) {
      _ctrl.centerLatLng.value = initialLocation!;
      _ctrl.locationLabel.value = initialLocationName ?? 'Loading...';
    }
  }

  Future<void> _onConfirmLocation() async {
    if (onLocationPicked != null) {
      final latLng = _ctrl.centerLatLng.value;
      final locationName = _ctrl.locationLabel.value;
      onLocationPicked!(latLng, locationName);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_resolvedStyle.value == null) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        body: Stack(
          children: [
            MapLibreMap(
              styleString: _resolvedStyle.value!,

              initialCameraPosition: CameraPosition(
                target: initialLocation ?? const LatLng(0, 0),
                zoom: 2,
              ),

              onMapCreated: (controller) {
                _ctrl.setMapController(controller);
              },

              onStyleLoadedCallback: () async {
                await Future.delayed(const Duration(milliseconds: 200));
                await _ctrl.refreshMapMarkers();
              },

              myLocationEnabled: true,
              myLocationTrackingMode: readOnly
                  ? MyLocationTrackingMode.none
                  : MyLocationTrackingMode.tracking,

              onCameraIdle: () async {
                if (_ctrl.mapController == null) return;

                final pos = _ctrl.mapController!.cameraPosition;
                if (pos == null) return;

                final lat = pos.target.latitude;
                final lng = pos.target.longitude;

                if (!BlinxMapTokens.isValidLatLng(lat, lng)) {
                  _ctrl.locationLabel.value = "Fetching location...";
                  return;
                }

                if (!_ctrl.isFirstLocationSet) return;

                _ctrl.centerLatLng.value = pos.target;
                _ctrl.isResolvingLocation.value = true;

                try {
                  final placemarks = await placemarkFromCoordinates(lat, lng);

                  if (placemarks.isNotEmpty) {
                    final p = placemarks.first;

                    final city = p.subLocality?.isNotEmpty == true
                        ? p.subLocality!
                        : p.locality?.isNotEmpty == true
                        ? p.locality!
                        : p.administrativeArea ?? '';

                    _ctrl.locationLabel.value = city.isNotEmpty
                        ? '$city, ${p.country ?? ""}'
                        : (p.country ?? "Unknown location");
                  } else {
                    _ctrl.locationLabel.value = "Location not found";
                  }
                } catch (e) {
                  _ctrl.locationLabel.value = "Fetching location...";
                } finally {
                  _ctrl.isResolvingLocation.value = false;
                }
              },
            ),

            // CENTER PIN
            Center(
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: _ctrl.isResolvingLocation.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _ctrl.locationLabel.value.isEmpty
                                  ? "Fetching location..."
                                  : _ctrl.locationLabel.value,
                              style: const TextStyle(fontSize: 12),
                            ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.location_pin,
                      size: 48,
                      color: Color(0xFF2A73EA),
                    ),
                  ],
                ),
              ),
            ),

            // BACK
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  CommonUi.setPngIcon('left_vector'),
                  width: 18,
                  height: 17,
                ),
              ),
            ),

            // CONFIRM BUTTON
            if (!readOnly)
              Positioned(
                bottom: 32,
                left: 24,
                right: 24,
                child: ElevatedButton(
                  onPressed: _onConfirmLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A73EA),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Confirm Location'),
                ),
              ),
          ],
        ),
      );
    });
  }
}
