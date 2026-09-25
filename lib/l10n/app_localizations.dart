import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('fr'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('fr'), Locale('en')];

  static const Map<String, Map<String, String>> _localizedValues = {
    'fr': {
      'appTitle': 'TaskCraft - Gestion Pro',
      'dashboard': 'Tableau de bord',
      'allTasks': 'Toutes les tâches',
      'completed': 'Terminées',
      'pending': 'En cours',
      'overdue': 'En retard',
      'totalTasks': 'Total Tâches',
      'completionRate': 'Taux de réussite',
      'searchHint': 'Rechercher une tâche ou un tag...',
      'filterCategory': 'Catégorie',
      'filterPriority': 'Priorité',
      'allCategories': 'Toutes',
      'allPriorities': 'Toutes',
      'noTasksFound': 'Aucune tâche trouvée',
      'noTasksSubtitle': 'Créez une nouvelle tâche pour commencer !',
      'addTask': 'Ajouter une tâche',
      'editTask': 'Modifier la tâche',
      'taskDetail': 'Détails de la tâche',
      'title': 'Titre',
      'description': 'Description',
      'category': 'Catégorie',
      'priority': 'Priorité',
      'dueDate': 'Date d\'échéance',
      'tags': 'Tags',
      'subtasks': 'Sous-tâches',
      'addSubtask': 'Ajouter une sous-tâche',
      'subtaskTitle': 'Titre de la sous-tâche',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'delete': 'Supprimer',
      'deleteConfirm': 'Voulez-vous vraiment supprimer cette tâche ?',
      'analytics': 'Statistiques',
      'settings': 'Paramètres',
      'language': 'Langue',
      'themeMode': 'Thème',
      'lightTheme': 'Clair',
      'darkTheme': 'Sombre',
      'systemTheme': 'Système',
      'profile': 'Profil Utilisateur',
      'version': 'Version de l\'application',
      'requiredField': 'Ce champ est obligatoire',
      'categoryWork': 'Travail',
      'categoryPersonal': 'Personnel',
      'categoryStudy': 'Études',
      'categoryTech': 'Tech',
      'priorityLow': 'Basse',
      'priorityMedium': 'Moyenne',
      'priorityHigh': 'Haute',
      'taskCreated': 'Tâche créée avec succès',
      'taskUpdated': 'Tâche mise à jour',
      'taskDeleted': 'Tâche supprimée',
      'exportData': 'Exporter les données',
      'resetData': 'Réinitialiser les données',
      'dataResetSuccess': 'Données réinitialisées',
    },
    'en': {
      'appTitle': 'TaskCraft - Pro Management',
      'dashboard': 'Dashboard',
      'allTasks': 'All Tasks',
      'completed': 'Completed',
      'pending': 'Pending',
      'overdue': 'Overdue',
      'totalTasks': 'Total Tasks',
      'completionRate': 'Completion Rate',
      'searchHint': 'Search task or tag...',
      'filterCategory': 'Category',
      'filterPriority': 'Priority',
      'allCategories': 'All',
      'allPriorities': 'All',
      'noTasksFound': 'No tasks found',
      'noTasksSubtitle': 'Create a new task to get started!',
      'addTask': 'Add Task',
      'editTask': 'Edit Task',
      'taskDetail': 'Task Details',
      'title': 'Title',
      'description': 'Description',
      'category': 'Category',
      'priority': 'Priority',
      'dueDate': 'Due Date',
      'tags': 'Tags',
      'subtasks': 'Subtasks',
      'addSubtask': 'Add Subtask',
      'subtaskTitle': 'Subtask Title',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'deleteConfirm': 'Are you sure you want to delete this task?',
      'analytics': 'Analytics',
      'settings': 'Settings',
      'language': 'Language',
      'themeMode': 'Theme Mode',
      'lightTheme': 'Light',
      'darkTheme': 'Dark',
      'systemTheme': 'System',
      'profile': 'User Profile',
      'version': 'App Version',
      'requiredField': 'This field is required',
      'categoryWork': 'Work',
      'categoryPersonal': 'Personal',
      'categoryStudy': 'Study',
      'categoryTech': 'Tech',
      'priorityLow': 'Low',
      'priorityMedium': 'Medium',
      'priorityHigh': 'High',
      'taskCreated': 'Task created successfully',
      'taskUpdated': 'Task updated',
      'taskDeleted': 'Task deleted',
      'exportData': 'Export Data',
      'resetData': 'Reset Data',
      'dataResetSuccess': 'Data reset successfully',
    },
  };

  String get(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ?? _localizedValues['en']?[key] ?? key;
  }

  String get appTitle => get('appTitle');
  String get dashboard => get('dashboard');
  String get allTasks => get('allTasks');
  String get completed => get('completed');
  String get pending => get('pending');
  String get overdue => get('overdue');
  String get totalTasks => get('totalTasks');
  String get completionRate => get('completionRate');
  String get searchHint => get('searchHint');
  String get filterCategory => get('filterCategory');
  String get filterPriority => get('filterPriority');
  String get allCategories => get('allCategories');
  String get allPriorities => get('allPriorities');
  String get noTasksFound => get('noTasksFound');
  String get noTasksSubtitle => get('noTasksSubtitle');
  String get addTask => get('addTask');
  String get editTask => get('editTask');
  String get taskDetail => get('taskDetail');
  String get title => get('title');
  String get description => get('description');
  String get category => get('category');
  String get priority => get('priority');
  String get dueDate => get('dueDate');
  String get tags => get('tags');
  String get subtasks => get('subtasks');
  String get addSubtask => get('addSubtask');
  String get subtaskTitle => get('subtaskTitle');
  String get save => get('save');
  String get cancel => get('cancel');
  String get delete => get('delete');
  String get deleteConfirm => get('deleteConfirm');
  String get analytics => get('analytics');
  String get settings => get('settings');
  String get language => get('language');
  String get themeMode => get('themeMode');
  String get lightTheme => get('lightTheme');
  String get darkTheme => get('darkTheme');
  String get systemTheme => get('systemTheme');
  String get profile => get('profile');
  String get version => get('version');
  String get requiredField => get('requiredField');
  String get taskCreated => get('taskCreated');
  String get taskUpdated => get('taskUpdated');
  String get taskDeleted => get('taskDeleted');
  String get exportData => get('exportData');
  String get resetData => get('resetData');
  String get dataResetSuccess => get('dataResetSuccess');

  String categoryName(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return get('categoryWork');
      case TaskCategory.personal:
        return get('categoryPersonal');
      case TaskCategory.study:
        return get('categoryStudy');
      case TaskCategory.tech:
        return get('categoryTech');
    }
  }

  String priorityName(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return get('priorityLow');
      case TaskPriority.medium:
        return get('priorityMedium');
      case TaskPriority.high:
        return get('priorityHigh');
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fr', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
