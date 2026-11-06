import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/date_labels.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool selected;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final overdue = !task.done && task.dueDate.isBefore(DateTime.now());
    final Color accent = task.done
        ? Colors.green
        : overdue
        ? scheme.error
        : scheme.primary;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: selected
          ? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.primary, width: 2),
      )
          : null,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 6, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: textTheme.titleMedium?.copyWith(
                                decoration: task.done
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              task.course,
                              style: textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.schedule, size: 16, color: accent),
                                const SizedBox(width: 4),
                                Text(
                                  dueLabel(task.dueDate, done: task.done),
                                  style: TextStyle(
                                    color: accent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (task.reminder)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.notifications_active_outlined,
                            size: 20,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      Icon(
                        task.done ? Icons.check_circle : Icons.chevron_right,
                        color: task.done ? Colors.green : scheme.outline,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}