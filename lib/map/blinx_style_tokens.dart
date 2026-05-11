abstract class BlinxMapTokens {
  BlinxMapTokens._();

  static const String mapTilerKey = "cRkGq3FWhpfoGCUq72gO";

  static const String localStyleAssetPath = 'assets/map/blinx_map_style.json';

  static const double fallbackLat = 28.6139;
  static const double fallbackLng = 77.2090;

  static const double defaultZoom = 13.0;
  static const double initialZoom = 2.0;

  static const double minZoom = 3.0;
  static const double maxZoom = 20.0;

  static const int blinxOrange = 0xFFFF5A1F;
  static const int blinxSurface = 0xFFF5F3EF;
  static const int blinxTextDark = 0xFF2C2C2C;
  static const int blinxTextMuted = 0xFF666666;
  static const int waterFill = 0xFFC8DFF0;
  static const int parkFill = 0xFFD4E8C8;
  static const int buildingFill = 0xFFDDD8D0;

  static const String pinRed = '#E53935';
  static const String pinOrange = '#FB8C00';
  static const String pinGreen = '#43A047';
  static const String pinBlue = '#1E88E5';
  static const String pinPurple = '#8E24AA';
  static const String pinDefault = '#FF5A1F';

  static const double markerRadiusSmall = 4.0;
  static const double markerRadiusDefault = 6.0;
  static const double markerRadiusLarge = 10.0;
  static const double markerStrokeWidth = 2.0;

  static const double sheetPeekHeight = 80.0;
  static const double sheetExpandedFrac = 0.75;

  static const double nearbyRadiusMetres = 1000.0;

  static const Duration cameraAnimDuration = Duration(milliseconds: 400);
  static const Duration sheetAnimDuration = Duration(milliseconds: 300);

  static const String blinxObjectSourceId = 'blinx_objects';
  static const String poiCircleLayerId = 'blinx-poi-circle';
  static const String poiCenterDotLayerId = 'blinx-poi-dot';
  static const String poiLabelLayerId = 'blinx-poi-label';

  // ── MY LOCATION PIN ─────
  static const String myLocationSourceId = 'my_location';
  static const String myLocationPulseLayerId = 'my-location-pulse';
  static const String myLocationDotLayerId = 'my-location-dot';

  // ── NEARBY USERS PINS ────
  static const String nearbyUsersSourceId = 'nearby_users';
  static const String nearbyUsersLayerId = 'nearby-users-circle';
  static const String nearbyUsersLabelLayerId = 'nearby-users-label';

  // HELPERS
  static bool isValidLatLng(double lat, double lng) {
    return !(lat == 0.0 && lng == 0.0);
  }

  //Map a topic slug
  static String topicColor(String? slug) {
    switch (slug) {
      case 'safety':
      case 'emergency':
        return pinRed;
      case 'environment':
      case 'nature':
        return pinGreen;
      case 'infrastructure':
      case 'roads':
        return pinOrange;
      case 'community':
      case 'public-spaces':
        return pinBlue;
      default:
        return pinDefault;
    }
  }
}
