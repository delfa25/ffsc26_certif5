import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/empty_state_widget.dart';
import '../l10n/app_localizations.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final taskProvider = context.watch<TaskProvider>();
    final filteredTasks = taskProvider.filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        elevation: 0,
        actions: [
          Semantics(
            label: l10n.analytics,
            hint: 'Open analytics and productivity score',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.bar_chart),
              tooltip: l10n.analytics,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                );
              },
            ),
          ),
          Semantics(
            label: l10n.settings,
            hint: 'Open app settings and preferences',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: l10n.settings,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick KPI Statistics
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.8,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StatCard(
                        title: l10n.totalTasks,
                        value: '${taskProvider.totalCount}',
                        icon: Icons.assignment_outlined,
                        color: Colors.blue,
                      ),
                      StatCard(
                        title: l10n.completionRate,
                        value:
                            '${(taskProvider.completionPercentage * 100).round()}%',
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  Semantics(
                    label: 'Search input field',
                    hint: 'Type title or tag to filter tasks',
                    textField: true,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.searchHint,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  taskProvider.setSearchQuery('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (val) => taskProvider.setSearchQuery(val),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Semantics(
                          label: 'Filter all categories',
                          button: true,
                          selected: taskProvider.selectedCategory == null,
                          child: FilterChip(
                            label: Text(l10n.allCategories),
                            selected: taskProvider.selectedCategory == null,
                            onSelected: (_) =>
                                taskProvider.setCategoryFilter(null),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ...TaskCategory.values.map((cat) {
                          final isSelected =
                              taskProvider.selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Semantics(
                              label:
                                  'Filter category ${l10n.categoryName(cat)}',
                              button: true,
                              selected: isSelected,
                              child: FilterChip(
                                label: Text(l10n.categoryName(cat)),
                                selected: isSelected,
                                onSelected: (_) =>
                                    taskProvider.setCategoryFilter(
                                  isSelected ? null : cat,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (taskProvider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (filteredTasks.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyStateWidget(
                title: l10n.noTasksFound,
                message: l10n.noTasksSubtitle,
                actionLabel: l10n.addTask,
                onAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TaskFormScreen()),
                  );
                },
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final task = filteredTasks[index];
                return TaskCard(
                  task: task,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailScreen(taskId: task.id),
                      ),
                    );
                  },
                  onToggle: (_) => taskProvider.toggleTaskCompletion(task.id),
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.delete),
                        content: Text(l10n.deleteConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(l10n.cancel),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(l10n.delete),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await taskProvider.deleteTask(task.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.taskDeleted)),
                        );
                      }
                    }
                  },
                );
              }, childCount: filteredTasks.length),
            ),
        ],
      ),
      floatingActionButton: Semantics(
        label: l10n.addTask,
        hint: 'Tap to open new task form',
        button: true,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TaskFormScreen()),
            );
          },
          icon: const Icon(Icons.add),
          label: Text(l10n.addTask),
        ),
      ),
    );
  }
}
