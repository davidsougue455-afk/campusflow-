import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/tasks_provider.dart';

class DetailContent extends StatelessWidget {
  final Task task;
  final VoidCallback onMarkDone;

  const DetailContent({super.key, required this.task, required this.onMarkDone});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final overdue = !task.done && task.dueDate.isBefore(DateTime.now());
    final Color statusColor = task.done
        ? Colors.green
        : overdue
        ? scheme.error
        : scheme.primary;
    final String statusLabel = task.done
        ? 'Fait'
        : overdue
        ? 'En retard'
        : 'À faire';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(task.title,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 20),
                  _InfoRow(
                    icon: Icons.menu_book_outlined,
                    label: 'Cours',
                    value: task.course,
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.schedule,
                    label: 'Échéance',
                    value: DateFormat('dd/MM/yyyy à HH:mm').format(task.dueDate),
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: task.reminder
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_off_outlined,
                    label: 'Rappel',
                    value: task.reminder ? 'Activé' : 'Désactivé',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    task.description.isEmpty
                        ? 'Aucune description'
                        : task.description,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: task.done ? null : onMarkDone,
            icon: const Icon(Icons.check),
            label: const Text('Marquer comme fait'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: scheme.onPrimaryContainer),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12, color: scheme.onSurfaceVariant)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

class DetailScreen extends ConsumerWidget {
  final String id;

  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tachesProvider);
    final matches = tasks.where((t) => t.id == id);
    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Détail')),
        body: const Center(child: Text('Tâche introuvable')),
      );
    }
    final task = matches.first;
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DetailContent(
          task: task,
          onMarkDone: () =>
              ref.read(tachesProvider.notifier).marquerFait(task.id),
        ),
      ),
    );
  }
}