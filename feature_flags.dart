import 'package:shared_preferences/shared_preferences.dart';

/// Simple feature flag services backed by [SharedPreferences].
///
/// Flags are toggled via the DevPanel (not yet implemented) and
/// persisted across sessions. The default values reflect the
/// desired configuration for early milestones: precise location is
/// off by default, the bridge panel is on, sweeps and tips are
/// off until explicitly enabled.
class FeatureFlags {
  FeatureFlags._internal();
  static final FeatureFlags _instance = FeatureFlags._internal();

  factory FeatureFlags() => _instance;

  bool _preciseLocation = false;
  bool _bridgePanel = true;
  bool _sweeps = false;
  bool _tips = false;

  bool get preciseLocation => _preciseLocation;
  bool get bridgePanel => _bridgePanel;
  bool get sweeps => _sweeps;
  bool get tips => _tips;

  /// Load flags from [SharedPreferences]. Must be called once at startup.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _preciseLocation = prefs.getBool('ffPreciseLocation') ?? _preciseLocation;
    _bridgePanel = prefs.getBool('ffBridgePanel') ?? _bridgePanel;
    _sweeps = prefs.getBool('ffSweeps') ?? _sweeps;
    _tips = prefs.getBool('ffTips') ?? _tips;
  }

  /// Update a flag and persist it. Unknown keys are ignored.
  Future<void> setFlag(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    switch (key) {
      case 'ffPreciseLocation':
        _preciseLocation = value;
        break;
      case 'ffBridgePanel':
        _bridgePanel = value;
        break;
      case 'ffSweeps':
        _sweeps = value;
        break;
      case 'ffTips':
        _tips = value;
        break;
      default:
        break;
    }
  }
}
