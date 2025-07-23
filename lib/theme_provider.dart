import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

void toggleTheme(WidgetRef ref) {
  final current = ref.read(themeModeProvider);
  ref.read(themeModeProvider.notifier).state =
      current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
}
final isDark = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  if (themeMode == ThemeMode.system) {
    // يرجع من إعدادات النظام
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
  return themeMode == ThemeMode.dark;
});
