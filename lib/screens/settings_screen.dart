import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/task_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsProvider>();
    final taskProvider = context.read<TaskProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Profile Header
          Semantics(
            label: 'User profile card',
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.person, color: Colors.white, size: 36),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mama Fadel DIAWARA',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Développeur Certified Flutter',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Preferences Group
          Text(
            'Préférences',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),

          // Theme Switcher
          Semantics(
            label: 'Select app theme mode',
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.brightness_6),
                title: Text(l10n.themeMode),
                subtitle: Text(
                  settings.themeMode == ThemeMode.dark
                      ? l10n.darkTheme
                      : settings.themeMode == ThemeMode.light
                          ? l10n.lightTheme
                          : l10n.systemTheme,
                ),
                trailing: DropdownButton<ThemeMode>(
                  value: settings.themeMode,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(l10n.systemTheme),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(l10n.lightTheme),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(l10n.darkTheme),
                    ),
                  ],
                  onChanged: (mode) {
                    if (mode != null) settings.setThemeMode(mode);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Language Switcher
          Semantics(
            label: 'Select application language',
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                subtitle: Text(
                  settings.locale.languageCode == 'fr' ? 'Français' : 'English',
                ),
                trailing: Switch(
                  value: settings.locale.languageCode == 'en',
                  onChanged: (_) {
                    settings.toggleLanguage();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Data Management Group
          Text(
            'Données & Réinitialisation',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const Icon(Icons.refresh, color: Colors.orange),
              title: Text(l10n.resetData),
              subtitle: const Text('Recharger les données de démonstration'),
              onTap: () async {
                await taskProvider.loadTasks();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.dataResetSuccess)),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),

          // App Info & Version
          Center(
            child: Text(
              'TaskCraft v1.0.0 (Certification FFSC26)',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
