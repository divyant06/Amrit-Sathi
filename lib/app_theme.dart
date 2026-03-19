import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// Central theme definitions
// ─────────────────────────────────────────────
abstract final class AppTheme {
  static const _seed = Color(0xFF14B8A6); // deep teal

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFF0B1120),
  );

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFFF1F5F9),
  );
}

// ─────────────────────────────────────────────
// Per-brightness colour palette
// ─────────────────────────────────────────────
class AppColors {
  final Color bg;
  final Color surface;
  final Color card;
  final Color border;
  final Color text;
  final Color subtext;
  final Color muted;
  final bool isDark;

  const AppColors._({
    required this.bg,
    required this.surface,
    required this.card,
    required this.border,
    required this.text,
    required this.subtext,
    required this.muted,
    required this.isDark,
  });

  static const _dark = AppColors._(
    bg:      Color(0xFF0B1120),
    surface: Color(0xFF111827),
    card:    Color(0xFF161F2E),
    border:  Color(0xFF1E2D42),
    text:    Color(0xFFE2E8F0),
    subtext: Color(0xFF94A3B8),
    muted:   Color(0xFF64748B),
    isDark:  true,
  );

  static const _light = AppColors._(
    bg:      Color(0xFFF1F5F9),
    surface: Color(0xFFFFFFFF),
    card:    Color(0xFFF8FAFC),
    border:  Color(0xFFE2E8F0),
    text:    Color(0xFF0F172A),
    subtext: Color(0xFF475569),
    muted:   Color(0xFF94A3B8),
    isDark:  false,
  );

  static AppColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? _dark : _light;
  }
}
