# Changelog - TaskCraft

Toutes les modifications notables apportées au projet **TaskCraft** sont documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/) et ce projet respecte les règles de [Semantic Versioning](https://semver.org/lang/fr/).

---

## [1.0.0] - 2026-03-30
### Ajouté
- **Production-Ready Release** pour la certification FFSC26 (Score ≥ 70/100 target).
- Support complet de l'Internationalisation (i10n) multilingue (Français & Anglais).
- Thème dynamique Material 3 avec basculement clair / sombre / système.
- Écran de statistiques et analytiques produit avec score d'efficacité et jauges de progression.
- Intégration complète de la suite de tests :
  - **15+ Tests Unitaires** (Modèles, Repositories, Providers, Analytics).
  - **6 Tests de Widgets** (TaskCard, StatCard, CustomButton, EmptyStateWidget, Screens).
  - **2 Tests d'Intégration End-to-End** (`integration_test/app_test.dart`).
- Configuration CI/CD GitHub Actions pour automatiser `flutter analyze`, `flutter test` et la compilation APK.
- Balises d'accessibilité `Semantics` sur l'ensemble des éléments interactifs et formulaires.

### Optimisé
- Rebuilds UI éliminés grâce aux constructeurs `const` et l'architecture Provider réactive.
- Analyse statique 100% propre (`flutter analyze` sans warnings ni infos).

---

## [0.2.0] - 2026-03-15
### Ajouté
- Écran de détails des tâches (`TaskDetailScreen`) avec gestion des sous-tâches (Subtasks).
- Écran de paramétrage (`SettingsScreen`) avec sélection de langue et réinitialisation de démo.
- Filtres dynamiques par recherche, catégories (`Work`, `Personal`, `Study`, `Tech`) et priorités (`Low`, `Medium`, `High`).

### Modifié
- Refactorisation de l'architecture vers la couche Repository (`ITaskRepository`) et découplage avec `TaskProvider`.

---

## [0.1.0] - 2026-03-01
### Ajouté
- Version initiale du projet **TaskCraft**.
- Structure de base avec `HomeScreen` et `TaskFormScreen`.
- Modèles de données `Task` et `Subtask`.
