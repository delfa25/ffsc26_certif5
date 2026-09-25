import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ffsc26_certif5/l10n/app_localizations.dart';
import 'package:ffsc26_certif5/models/task.dart';

void main() {
  group('AppLocalizations Unit Tests', () {
    test('AppLocalizations returns French translations for fr locale', () {
      final l10nFr = AppLocalizations(const Locale('fr'));
      expect(l10nFr.appTitle, equals('TaskCraft - Gestion Pro'));
      expect(l10nFr.addTask, equals('Ajouter une tâche'));
      expect(l10nFr.categoryName(TaskCategory.work), equals('Travail'));
      expect(l10nFr.priorityName(TaskPriority.high), equals('Haute'));
    });

    test('AppLocalizations returns English translations for en locale', () {
      final l10nEn = AppLocalizations(const Locale('en'));
      expect(l10nEn.appTitle, equals('TaskCraft - Pro Management'));
      expect(l10nEn.addTask, equals('Add Task'));
      expect(l10nEn.categoryName(TaskCategory.work), equals('Work'));
      expect(l10nEn.priorityName(TaskPriority.high), equals('High'));
    });

    test('Supported locales list contains fr and en', () {
      expect(AppLocalizations.supportedLocales, contains(const Locale('fr')));
      expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
      expect(AppLocalizations.supportedLocales.length, equals(2));
    });
  });
}
