import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/screens/location/location_page.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:food_delivery/theme/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends ConsumerStatefulWidget {
  static const routeName = '/settings';
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      backgroundColor:
          themeMode == ThemeMode.dark ? AppColors.secondary : Colors.white,
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: themeMode == ThemeMode.dark
              ? AppColors.secondary_white
              : AppColors.dark_grey,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
            ),
          ),
        ),
        backgroundColor:
            themeMode == ThemeMode.dark ? Colors.white : AppColors.secondary,
        title: Text('settings'.tr(),
            style: GoogleFonts.sen(
                color:
                    themeMode == ThemeMode.dark ? Colors.black : Colors.white)),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: FaIcon(
                themeMode == ThemeMode.dark
                    ? FontAwesomeIcons.moon
                    : FontAwesomeIcons.sun,
                color:
                    themeMode == ThemeMode.dark ? Colors.white : Colors.black),
            title: Text('Theme'.tr(),
                style: GoogleFonts.sen(
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black)),
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (val) {
                toggleTheme(ref);
                // saveThemeMode(themeMode);
                // ref.read(themeModeProvider.notifier).state =
                //     val ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.language,
                color:
                    themeMode == ThemeMode.dark ? Colors.white : Colors.black),
            title: Text('Language'.tr(),
                style: GoogleFonts.sen(
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black)),
            trailing: DropdownButton<Locale>(
              dropdownColor: themeMode == ThemeMode.dark
                  ? AppColors.primary
                  : Colors.white,
              style: GoogleFonts.sen(
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              icon: Icon(Icons.arrow_drop_down,
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black),
              value: context.locale,
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('ar'),
                  child: Text('العربية'),
                ),
              ],
              onChanged: (locale) async {
                if (locale != null) {
                  await context.setLocale(locale);
                  setState(() {}); // Force rebuild to update UI
                }
              },
            ),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.locationArrow,
                color:
                    themeMode == ThemeMode.dark ? Colors.white : Colors.black),
            title: Text('location'.tr(),
                style: GoogleFonts.sen(
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black)),
            trailing: IconButton(
                onPressed: () => Navigator.pushNamed(
                      context,
                      LocationAccessPage.routeName,
                    ),
                icon: const Icon(Icons.arrow_forward_ios)),
          ),
        ],
      ),
    );
  }
}
