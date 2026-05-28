import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class AppPalette {
  final Color bg;
  final Color surface;
  final Color card;
  final Color onCard;
  final Color accent;
  final Color accentDim;
  final Color danger;
  final Color onDanger;

  const AppPalette({
    required this.bg,
    required this.surface,
    required this.card,
    required this.onCard,
    required this.accent,
    required this.accentDim,
    required this.danger,
    required this.onDanger,
  });

  static const AppPalette dark = AppPalette(
    bg: Color(0xFF121210),
    surface: Color(0xFF1E2015),
    card: Color(0xFF2A2C21),
    onCard: Color(0xFFE5DDD2),
    accent: Color(0xFF827F5E),
    accentDim: Color(0xCF5A5840),
    danger: Color(0xFFFF3A2A),
    onDanger: Color(0xFFF5F2ED),
  );

  static const AppPalette light = AppPalette(
    bg: Color(0xFFF5F2ED),
    surface: Color(0xFFE5DDD2),
    card: Color(0xFFE5DDD2),
    onCard: Color(0xFF1E2015),
    accent: Color(0xFF827F5E),
    accentDim: Color(0xFFB0AD8E),
    danger: Color(0xFF684D3A),
    onDanger: Color(0xFFF5F2ED),
  );
}

class ThemeService extends ChangeNotifier {
  final SharedPreferences _prefs;
  bool _isDark;

  ThemeService(this._prefs) : _isDark = _prefs.getBool('is_dark') ?? true;

  bool get isDark => _isDark;

  AppPalette get colors => _isDark ? AppPalette.dark : AppPalette.light;

  void toggleTheme() {
    _isDark = !_isDark;
    _prefs.setBool('is_dark', _isDark);
    notifyListeners();
  }
}
