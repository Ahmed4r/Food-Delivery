import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// Call this once at app startup
Future<void> loadSavedThemeMode(ProviderContainer container) async {
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('themeMode');

  ThemeMode mode;
  switch (savedTheme) {
    case 'ThemeMode.dark':
      mode = ThemeMode.dark;
      break;
    case 'ThemeMode.light':
      mode = ThemeMode.light;
      break;
    case 'ThemeMode.system':
      mode = ThemeMode.system;
      break;
    default:
      mode = ThemeMode.light;
  }

  container.read(themeModeProvider.notifier).state = mode;
}

Future<void> saveThemeMode(ThemeMode themeMode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('themeMode', themeMode.toString());
}

void toggleTheme(WidgetRef ref) async {
  final current = ref.read(themeModeProvider);
  final newMode = current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

  ref.read(themeModeProvider.notifier).state = newMode;
  await saveThemeMode(newMode);
}

final isDark = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  if (themeMode == ThemeMode.system) {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
  return themeMode == ThemeMode.dark;
});
