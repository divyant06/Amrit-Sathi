import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────
// PrefsService — singleton wrapper around SharedPreferences
// ─────────────────────────────────────────────
class PrefsService {
  PrefsService._(this._prefs);

  final SharedPreferences _prefs;

  // Singleton instance — set by init()
  static late PrefsService instance;

  /// Must be called once before runApp.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    instance = PrefsService._(prefs);
  }

  // ── Keys ──
  static const _kUserName = 'userName';
  static const _kTravelStyle = 'travelStyle';

  // ── userName ──
  String get userName => _prefs.getString(_kUserName) ?? 'Traveler';

  Future<void> setUserName(String value) =>
      _prefs.setString(_kUserName, value);

  // ── travelStyle ──
  String get travelStyle =>
      _prefs.getString(_kTravelStyle) ?? 'Budget Explorer';

  Future<void> setTravelStyle(String value) =>
      _prefs.setString(_kTravelStyle, value);
}
