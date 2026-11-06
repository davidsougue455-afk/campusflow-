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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(task.course),
                const SizedBox(height: 8),
                Text('Échéance : ${DateFormat('dd/MM/yyyy').format(task.dueDate)}'),
                const SizedBox(height: 8),
                Text(task.done ? 'Statut : fait' : 'Statut : à faire'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: task.done ? null : onMarkDone,
            child: const Text('Marquer comme fait'),
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
      appBar: AppBar(title: const Text('Détail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DetailContent(
          task: task,
          onMarkDone: () => ref.read(tachesProvider.notifier).marquerFait(task.id),
        ),
      ),
    );
  }
}