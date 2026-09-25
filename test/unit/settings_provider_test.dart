import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/providers/settings_provider.dart';

void main() {
  group('SettingsProvider Unit Tests', () {
    late SettingsProvider settings;

    setUp(() {
      settings = SettingsProvider();
    });

    test('Initial theme mode is ThemeMode.system and locale is fr', () {
      expect(settings.themeMode, equals(ThemeMode.system));
      expect(settings.locale, equals(const Locale('fr')));
    });

    test('setThemeMode changes themeMode and notifies listeners', () {
      bool notified = false;
      settings.addListener(() {
        notified = true;
      });

      settings.setThemeMode(ThemeMode.dark);

      expect(settings.themeMode, equals(ThemeMode.dark));
      expect(notified, isTrue);
    });

    test('toggleTheme toggles between light and dark theme', () {
      settings.setThemeMode(ThemeMode.light);
      expect(settings.themeMode, equals(ThemeMode.light));

      settings.toggleTheme();
      expect(settings.themeMode, equals(ThemeMode.dark));

      settings.toggleTheme();
      expect(settings.themeMode, equals(ThemeMode.light));
    });

    test('setLocale and toggleLanguage update locale properly', () {
      settings.setLocale(const Locale('en'));
      expect(settings.locale.languageCode, equals('en'));

      settings.toggleLanguage();
      expect(settings.locale.languageCode, equals('fr'));

      settings.toggleLanguage();
      expect(settings.locale.languageCode, equals('en'));
    });
  });
}
