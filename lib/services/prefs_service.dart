import 'dart:convert';
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
  static const _kUserName    = 'userName';
  static const _kTravelStyle = 'travelStyle';
  static const _kCopilotChat = 'copilotChat';

  // ── userName ──
  String get userName => _prefs.getString(_kUserName) ?? 'Traveler';

  Future<void> setUserName(String value) =>
      _prefs.setString(_kUserName, value);

  // ── travelStyle ──
  String get travelStyle =>
      _prefs.getString(_kTravelStyle) ?? 'Budget Explorer';

  Future<void> setTravelStyle(String value) =>
      _prefs.setString(_kTravelStyle, value);

  // ── Copilot chat history ──

  /// Persists messages as a JSON-encoded list of {role, text, timestamp} maps.
  Future<void> saveChat(List<Map<String, String>> messages) async {
    await _prefs.setString(_kCopilotChat, jsonEncode(messages));
  }

  /// Returns saved messages, or an empty list if nothing is stored yet.
  List<Map<String, String>> loadChat() {
    final raw = _prefs.getString(_kCopilotChat);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => Map<String, String>.from(e as Map))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Wipes saved chat (e.g. for a "clear history" feature in future).
  Future<void> clearChat() => _prefs.remove(_kCopilotChat);
}
