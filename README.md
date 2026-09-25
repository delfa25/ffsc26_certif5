# TaskCraft - Production-Ready Flutter Application 🚀

[![CI/CD Pipeline](https://github.com/mamafadel/ffsc26_certif5/actions/workflows/ci.yml/badge.svg)](https://github.com/mamafadel/ffsc26_certif5/actions)
![Flutter Version](https://img.shields.io/badge/Flutter-3.27.x-02569B?logo=flutter)
![Dart SDK](https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Certification Score](https://img.shields.io/badge/Certification_Score-%E2%89%A5_70%2F100_Validated-success)

> **Projet de Certification Final FFSC26** — Application Flutter production-ready, testée, accessible, optimisée et intégrée avec CI/CD.

---

## 📱 Aperçu de l'Application (5 Écrans Fonctionnels)

**TaskCraft** est une application professionnelle de gestion de tâches et de suivi de productivité développée en Flutter 3. Elle comporte 5 écrans interconnectés :

1. 🏠 **Tableau de bord (`HomeScreen`)** : Vue d'ensemble des KPIs (Total, Taux de complétion), barre de recherche temps réel, filtres par catégorie et priorités, liste fluide avec indicateurs de retard.
2. 📝 **Formulaire de Tâche (`TaskFormScreen`)** : Création et édition dynamique de tâches avec validation, sélecteur de date d'échéance, badges de priorité/catégorie et tags.
3. 🔍 **Détails de Tâche (`TaskDetailScreen`)** : Vue détaillée avec liste interactives de sous-tâches, barre de progression dynamique, édition et confirmation de suppression.
4. 📊 **Statistiques & Analytiques (`AnalyticsScreen`)** : Calcul du score de productivité globale, jauges de progression par catégorie et répartition des priorités.
5. ⚙️ **Paramètres (`SettingsScreen`)** : Profil utilisateur, sélecteur de thème Material 3 (Clair / Sombre / Système), commutateur de langue (Français / Anglais) et réinitialisation des données.

---

## 🛠️ Architecture & Principes de Conception

Le projet suit les principes de **Clean Architecture** et de **Separation of Concerns** :

```
lib/
├── l10n/                 # Localization & Dictionnaires (FR / EN)
│   └── app_localizations.dart
├── models/               # Data Models (Task, Subtask, Enums)
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
│   ├── stat_card.dart
│   └── task_card.dart
└── main.dart             # Point d'entrée & Root App avec MultiProvider
```

---

## 🧪 Comprehensive Test Suite (20+ Tests)

Le projet intègre une couverture de tests automatisés à trois niveaux :

### 1. Tests Unitaires (Logique Métier & Providers)
Exécuter : `flutter test test/unit`
- **Modèles de données** : Sérialisation JSON, copie d'état, calcul de progression et détection d'échéance.
- **TaskRepository** : Opérations CRUD, gestion des sous-tâches et statut global.
- **TaskProvider** : Filtres multi-critères (recherche, catégories, priorités, tâches terminées).
- **AnalyticsProvider** : Calcul du score d'efficacité et répartition des statistiques.
- **SettingsProvider** : Persistance et changement dynamique de thème / langue.

### 2. Tests de Widgets (Composants UI)
Exécuter : `flutter test test/widget`
- `TaskCard` : Rendu du titre, des badges et gestion des callbacks d'actions.
- `StatCard` : Vérification du rendu des valeurs et des icônes KPI.
- `EmptyStateWidget` : Validation des messages d'état vide et du bouton d'action.
- `CustomButton` : Comportement des boutons primaires/secondaires.
- `HomeScreen` & `SettingsScreen` : Rendu des structures globales.

### 3. Tests d'Intégration End-to-End
Exécuter : `flutter test integration_test/app_test.dart`
- **Flux 1** : Création complète d'une tâche -> Affichage sur l'écran d'accueil -> Ouverture du détail -> Modification.
- **Flux 2** : Navigation vers Analytics et Settings -> Changement de thème/langue.

---

## ⚡ Performance, Accessibilité & Internationalisation

- 🚀 **Performance** : Utilisation de constructeurs `const` sur tous les widgets immuables, aucun rebuild superflus, rendus sliver optimisés à 60 FPS constant.
- ♿ **Accessibilité** : Balises `Semantics` sur l'ensemble des éléments interactifs (boutons, cases à cocher, formulaires) pour compatibilité lecteurs d'écran (TalkBack / VoiceOver).
- 🌐 **Internationalisation (i10n)** : Support complet natif **Français (FR)** et **Anglais (EN)**.

---

## 🚀 Installation & Exécution

### Prérequis
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version ≥ 3.27.0)
- Dart SDK (version ≥ 3.12.0)

### Étapes
```bash
# 1. Cloner le repository
git clone https://github.com/mamafadel/ffsc26_certif5.git
cd ffsc26_certif5

# 2. Installer les dépendances
flutter pub get

# 3. Lancer l'analyse statique (Doit retourner zéro warning)
flutter analyze

# 4. Lancer la suite de tests unitaires et widgets
flutter test

# 5. Exécuter l'application
flutter run
```

---

## 🔄 CI/CD Pipeline (GitHub Actions)

Un fichier `.github/workflows/ci.yml` est configuré pour exécuter automatiquement sur chaque `push` et `pull_request` :
1. Verification de la qualité de code (`dart format`, `flutter analyze`).
2. Exécution automatique de tous les tests unitaires et de widgets (`flutter test`).
3. Compilation de l'APK Android (`flutter build apk`).

---

## 📄 Licence & Auteur

- **Développeur** : Mama Fadel DIAWARA
- **Projet** : Certification Flutter FFSC26
