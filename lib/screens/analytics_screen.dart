import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/analytics_provider.dart';
import '../widgets/stat_card.dart';
import '../l10n/app_localizations.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final taskProvider = context.watch<TaskProvider>();
    final analytics = AnalyticsProvider();

    final tasks = taskProvider.tasks;
    final categoryStats = analytics.getCategoryStats(tasks);
    final priorityDist = analytics.getPriorityDistribution(tasks);
    final score = analytics.calculateOverallScore(tasks);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.analytics)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Productivity Score Header
            Card(
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Score d\'efficacité',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${score.toInt()} / 100',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            score >= 70
                                ? 'Excellente productivité !'
                                : 'Continue tes efforts !',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.emoji_events,
                      size: 60,
                      color: Colors.amberAccent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Metric Overview Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                StatCard(
                  title: l10n.completed,
                  value: '${taskProvider.completedCount}',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                StatCard(
                  title: l10n.pending,
                  value: '${taskProvider.pendingCount}',
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                ),
                StatCard(
                  title: l10n.overdue,
                  value: '${taskProvider.overdueCount}',
                  icon: Icons.warning_amber,
                  color: Colors.red,
                ),
                StatCard(
                  title: l10n.totalTasks,
                  value: '${taskProvider.totalCount}',
                  icon: Icons.all_inbox,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Category Breakdown Progress Bars
            Text(
              'Répartition par catégorie',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...categoryStats.map((stat) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.categoryName(stat.category)),
                        Text('${stat.completedTasks}/${stat.totalTasks}'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: stat.completionRate,
                        minHeight: 10,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // Priority Distribution Summary
            Text(
              'Distribution des priorités',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: priorityDist.entries.map((e) {
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 6,
                        backgroundColor: e.key == TaskPriority.high
                            ? Colors.red
                            : e.key == TaskPriority.medium
                                ? Colors.orange
                                : Colors.green,
                      ),
                      title: Text(l10n.priorityName(e.key)),
                      trailing: Text(
                        '${e.value} tâches',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
