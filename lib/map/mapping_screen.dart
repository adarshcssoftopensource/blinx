import 'package:blinx_mobile/map/blinx_map_controller.dart';
import 'package:blinx_mobile/map/blinx_map_style_install.dart';
import 'package:blinx_mobile/map/blinx_style_tokens.dart';
import 'package:blinx_mobile/map/mapping_controller.dart';
import 'package:blinx_mobile/social_pulse_screen/post_detail_screen/view/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

// MAPPING SCREEN — Nearby Blinks
class MappingScreen extends StatelessWidget {
  MappingScreen({super.key}) {
    _loadStyle();
  }

  final MappingController _ctrl = Get.put(
    MappingController(),
    permanent: false,
  );

  final RxnString _resolvedStyle = RxnString();

  Future<void> _loadStyle() async {
    final style = await BlinxMapStyleInstaller.resolvedStyleString();
    _resolvedStyle.value = style;
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
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // MAP AREA
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: MapLibreMap(
                      styleString: _resolvedStyle.value!,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(0, 0),
                        zoom: BlinxMapTokens.initialZoom,
                      ),
                      myLocationEnabled: false,
                      compassEnabled: false,
                      myLocationTrackingMode: MyLocationTrackingMode.none,
                      onMapCreated: (controller) {
                        _ctrl.setMapController(controller);
                      },
                      onStyleLoadedCallback: () async {
                        await Future.delayed(const Duration(milliseconds: 300));
                        _ctrl.onStyleReady();
                      },
                      onMapClick: (point, latLng) {
                        _ctrl.clearSelection();
                      },
                    ),
                  ),

                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Header(ctrl: _ctrl),
                            const SizedBox(height: 8),
                            _TopicChips(ctrl: _ctrl),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        _MapButton(
                          icon: Icons.navigation_outlined,
                          label: 'Re-center',
                          onTap: _ctrl.reCenterToMyLocation,
                        ),
                        const Spacer(),
                        _MapButton(
                          icon: Icons.refresh_rounded,
                          label: 'Use This Area',
                          onTap: _ctrl.useThisArea,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _NearbyBlinksList(ctrl: _ctrl),
          ],
        ),
      );
    });
  }
}

// HEADER
class _Header extends StatelessWidget {
  final MappingController ctrl;
  const _Header({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.location_on, color: Color(0xFFE53935), size: 20),
          const SizedBox(width: 6),
          Expanded(
            child: Obx(() {
              final isResolving =
                  ctrl.isResolvingLocation.value ||
                  ctrl.isLocationLoading.value;
              final label = ctrl.locationLabel.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Nearby Blinks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  if (isResolving)
                    const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Colors.grey,
                      ),
                    )
                  else
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              );
            }),
          ),
          Obx(
            () => ctrl.isLoadingNearby.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF2A73EA),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// TOPIC CHIPS
class _TopicChips extends StatelessWidget {
  final MappingController ctrl;
  const _TopicChips({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final topics = ctrl.availableTopics;
      final selected = ctrl.selectedTopicSlug.value;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _Chip(
              label: 'All',
              isSelected: selected == null,
              onTap: () => ctrl.applyTopicFilter(null),
            ),
            const SizedBox(width: 8),
            ...topics.map(
              (topic) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _Chip(
                  label: topic.name,
                  isSelected: selected == topic.slug,
                  onTap: () => ctrl.applyTopicFilter(topic.slug),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A73EA) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// MAP BUTTON
class _MapButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MapButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.black87),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _hexColor(String hex) {
  try {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  } catch (_) {
    return const Color(0xFFE8F1FF);
  }
}

class _BlinkCardItem extends StatelessWidget {
  final BlinxObject blink;
  const _BlinkCardItem({required this.blink});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            _BlinkThumb(blink: blink),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (blink.topic != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _hexColor(blink.topic!.color),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          blink.topic!.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2A73EA),
                          ),
                        ),
                      ),
                    const SizedBox(height: 5),
                    Text(
                      blink.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _Avatar(blink: blink),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            blink.author?.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Text(
                          blink.timeAgoLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (blink.imageUrl != null && blink.imageUrl!.isNotEmpty)
              SizedBox(
                width: 72,
                height: 110,
                child: Image.network(blink.imageUrl!, fit: BoxFit.cover),
              ),
          ],
        ),
      ),
    );
  }

  Color _hexColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFFE8F1FF);
    }
  }
}

// BLINK LEFT THUMB
class _BlinkThumb extends StatelessWidget {
  final BlinxObject blink;
  const _BlinkThumb({required this.blink});

  @override
  Widget build(BuildContext context) {
    Color bg;
    try {
      bg = Color(
        int.parse((blink.topic?.color ?? '#E8F1FF').replaceFirst('#', '0xFF')),
      ).withOpacity(0.35);
    } catch (_) {
      bg = const Color(0xFFE8F1FF);
    }

    if (blink.imageUrl != null && blink.imageUrl!.isNotEmpty) {
      return SizedBox(
        width: 80,
        height: 110,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          child: Image.network(
            blink.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _colorBox(bg),
          ),
        ),
      );
    }

    return _colorBox(bg);
  }

  Widget _colorBox(Color bg) {
    return Container(
      width: 80,
      height: 110,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: const Icon(Icons.location_on, color: Colors.white60, size: 28),
    );
  }
}

// AUTHOR AVATAR
class _Avatar extends StatelessWidget {
  final BlinxObject blink;
  const _Avatar({required this.blink});

  @override
  Widget build(BuildContext context) {
    final img = blink.author?.profileImage;
    if (img != null && img.isNotEmpty) {
      return CircleAvatar(
        radius: 10,
        backgroundImage: NetworkImage(img),
        backgroundColor: Colors.grey.shade200,
      );
    }
    return CircleAvatar(
      radius: 10,
      backgroundColor: Colors.grey.shade300,
      child: Text(
        (blink.author?.name ?? '?').substring(0, 1).toUpperCase(),
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _NearbyBlinksList extends StatelessWidget {
  final MappingController ctrl;
  const _NearbyBlinksList({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final blinks = ctrl.nearbyBlinks;

      if (blinks.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 130,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: blinks.length,
          itemBuilder: (context, index) {
            final blink = blinks[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => PostDetailScreen(blinkId: blink.id));
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: _BlinkCardItem(blink: blink),
              ),
            );
          },
        ),
      );
    });
  }
}
