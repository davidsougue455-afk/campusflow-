import 'package:flutter/material.dart';
import '../models/task.dart';

class DetailScreen extends StatelessWidget {
  final Task task;

  const DetailScreen({super.key, required this.task});

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                    Text('Échéance : ${_formatDate(task.dueDate)}'),
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
                onPressed: task.done
                    ? null
                    : () => Navigator.pop(context, task.copyWith(done: true)),
                child: const Text('Marquer comme fait'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}