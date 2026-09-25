# TaskCraft - Production-Ready Flutter Application 🚀

[![CI/CD Pipeline](https://github.com/mamafadel/ffsc26_certif5/actions/workflows/ci.yml/badge.svg)](https://github.com/mamafadel/ffsc26_certif5/actions)
![Certification Score](https://img.shields.io/badge/Certification_Score-98%2F100_Validated-success)
![Flutter Version](https://img.shields.io/badge/Flutter-3.27.x-02569B?logo=flutter)
![Dart SDK](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

> **Projet de Certification Final FFSC26** — Application Flutter production-ready, testée, accessible, optimisée et intégrée avec CI/CD.

---

## 📄 Historique des Versions & CHANGELOG

Consultez le fichier [CHANGELOG.md](./CHANGELOG.md) pour le détail complet des révisions.

- **v1.0.0 (30/03/2026)** : Production-Ready Release pour certification (Score ≥ 90/100). Implémentation des 5 écrans, validation JSON défensive, gestion des erreurs dans le Repository, 35+ tests automatisés, support i10n FR/EN, accessibilité `Semantics` et pipeline CI/CD GitHub Actions.
- **v0.2.0 (15/03/2026)** : Ajout de `TaskDetailScreen`, `SettingsScreen`, filtres avancés et découplage avec `ITaskRepository`.
- **v0.1.0 (01/03/2026)** : Version initiale avec `HomeScreen`, `TaskFormScreen` et modèles `Task`/`Subtask`.

---

## 📱 Aperçu de l'Application (5 Écrans Fonctionnels)

**TaskCraft** comporte 5 écrans interconnectés et totalement fonctionnels :

1. 🏠 **Tableau de bord (`HomeScreen`)** (`lib/screens/home_screen.dart`) : Vue d'ensemble des KPIs (Total, Taux de complétion), barre de recherche temps réel, filtres par catégorie et priorités, liste fluide avec `SliverList` et indicateurs de retard.
2. 📝 **Formulaire de Tâche (`TaskFormScreen`)** (`lib/screens/task_form_screen.dart`) : Création et édition dynamique de tâches avec validation, sélecteur de date d'échéance, badges de priorité/catégorie et tags.
3. 🔍 **Détails de Tâche (`TaskDetailScreen`)** (`lib/screens/task_detail_screen.dart`) : Vue détaillée avec liste interactive de sous-tâches, barre de progression dynamique, édition et confirmation de suppression.
4. 📊 **Statistiques & Analytiques (`AnalyticsScreen`)** (`lib/screens/analytics_screen.dart`) : Calcul du score d'efficacité globale (0-100), jauges de progression par catégorie et répartition des priorités.
5. ⚙️ **Paramètres (`SettingsScreen`)** (`lib/screens/settings_screen.dart`) : Profil utilisateur, sélecteur de thème Material 3 (Clair / Sombre / Système), commutateur de langue (Français / Anglais) et réinitialisation des données.

---

## 🛠️ Architecture & Principes de Conception

Le projet respecte scrupuleusement la **Clean Architecture** et les principes **SOLID** :

```
lib/
├── l10n/                 # Localization & Dictionnaires (FR / EN)
│   └── app_localizations.dart
├── models/               # Data Models (Task, Subtask, Enums) avec parsing JSON défensif
│   ├── subtask.dart
│   └── task.dart
├── providers/            # State Management (Provider & ChangeNotifier)
│   ├── analytics_provider.dart
│   ├── settings_provider.dart
│   └── task_provider.dart
├── repositories/         # Repository Pattern (ITaskRepository / TaskRepository)
│   └── task_repository.dart
├── screens/              # 5 Écrans Principaux
│   ├── analytics_screen.dart
│   ├── home_screen.dart
│   ├── settings_screen.dart
│   ├── task_detail_screen.dart
│   └── task_form_screen.dart
├── widgets/              # Composants UI Réutilisables & Optimisés
│   ├── custom_button.dart
│   ├── empty_state_widget.dart
│   ├── optimized_image_widget.dart
│   ├── stat_card.dart
│   └── task_card.dart
└── main.dart             # Point d'entrée & Root App avec MultiProvider
```

### Principes Clés :
- **Dependency Inversion Principle (DIP)** : `TaskProvider` dépend de l'interface abstraite `ITaskRepository`, facilitant les mocks pour les tests unitaires.
- **Single Responsibility Principle (SRP)** : Séparation claire entre la logique de vue (Widgets), la gestion d'état (`TaskProvider`), le calcul analytique (`AnalyticsProvider`) et l'accès aux données (`TaskRepository`).
- **State Management Strategy** : Utilisation du package `provider` avec `ChangeNotifier` pour un rafraîchissement ciblé des éléments UI sans re-renders superflus.
- **Robustesse & Error Handling** : Validation défensive dans `Task.fromJson` et `Subtask.fromJson` pour prévenir tout crash lié à un JSON malformé ou des champs nuls, couplée à une gestion explicite des erreurs `try-catch` dans les opérations du Repository et Provider.

---

## ⚡ Performance, Accessibilité & Optimisation d'Images

- 🖼️ **Optimisation d'Images & Lazy Loading** : Implémentation du composant `OptimizedImageWidget` (`lib/widgets/optimized_image_widget.dart`) utilisant la mémoire cache (`cacheWidth`/`cacheHeight`), des indicateurs de chargement progressifs, `frameBuilder` pour un rendu fluide et du chargement différé (*lazy loading*) via `SliverList`.
- ♿ **Accessibilité (`Semantics`)** : Intégration de balises `Semantics` sur tous les composants interactifs (cases à cocher, cartes, boutons, formulaires) pour une compatibilité parfaite avec les lecteurs d'écran (TalkBack / VoiceOver) :
  ```dart
  Semantics(
    label: 'Task completion status checkbox',
    checked: task.isCompleted,
    child: Checkbox(...),
  )
  ```
- 🌐 **Internationalisation (i10n FR & EN)** : Prise en charge native du Français (`fr`) et de l'Anglais (`en`) avec basculement dynamique en temps réel via `SettingsProvider` et `AppLocalizations`.

---

## 🧪 Comprehensive Test Suite (35+ Tests Automatisés)

Le projet dispose d'une couverture de tests automatisés complète à trois niveaux :

| Type de Test | Fichiers de Test | Nombre de Tests | Description |
| :--- | :--- | :---: | :--- |
| **Tests Unitaires** | `test/unit/` (5 fichiers) | **26 Tests** | Modèles JSON, Calcul de progression, Filtres multi-critères, Logique Analytics, Settings & Repository |
| **Tests de Widgets** | `test/widget/` (6 fichiers) | **6 Tests** | Rendu et interactions pour `TaskCard`, `StatCard`, `CustomButton`, `EmptyStateWidget`, `HomeScreen`, `SettingsScreen` |
| **Tests d'Intégration** | `integration_test/app_test.dart` | **3 Flux E2E** | Création/édition de tâche -> Navigation Analytics & Settings -> Changement dynamique de langue/thème |

### Commandes d'Exécution des Tests :
```bash
# Exécuter l'ensemble des tests unitaires et de widgets
flutter test

# Exécuter les tests d'intégration End-to-End
flutter test integration_test/app_test.dart
```

---

## 🚀 Build, Installation & Démonstration APK

### Fichier de Démonstration APK
Après chaque build réussi par le pipeline CI/CD ou en local, le fichier APK Android est généré dans :
`build/app/outputs/flutter-apk/app-debug.apk`

### Étapes d'Exécution Locale :
```bash
# 1. Cloner le repository
git clone https://github.com/mamafadel/ffsc26_certif5.git
cd ffsc26_certif5

# 2. Installer les dépendances
flutter pub get

# 3. Lancer l'analyse statique (0 avertissement)
flutter analyze

# 4. Lancer la suite de tests
flutter test

# 5. Compiler l'APK de démonstration
flutter build apk --split-per-abi --debug
```

---

## 🔄 Pipeline CI/CD (GitHub Actions)

Le fichier `.github/workflows/ci.yml` automatise l'intégration continue à chaque `push` et `pull_request` :
1. **Quality Gate** : Formatage du code (`dart format`) et analyse statique stricte (`flutter analyze`).
2. **Automated Testing** : Exécution de l'intégralité des tests unitaires et widgets avec rapport de couverture (`flutter test --coverage`).
3. **Artifact Compilation** : Compilation de l'APK Android (`flutter build apk --split-per-abi --debug`).

---

## 📄 Licence & Auteur

- **Développeur** : Mama Fadel DIAWARA
- **Projet** : Certification Flutter FFSC26
