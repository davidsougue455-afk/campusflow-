import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/tasks_provider.dart';
import 'detail_screen.dart';

class DeadlinesScreen extends ConsumerStatefulWidget {
  const DeadlinesScreen({super.key});

  @override
  ConsumerState<DeadlinesScreen> createState() => _DeadlinesScreenState();
}

class _DeadlinesScreenState extends ConsumerState<DeadlinesScreen> {
  String? _selectedId;

  String _formatDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

  Widget _buildFiltres() {
    final actuel = ref.watch(filtreProvider);
    const labels = {
      Filtre.toutes: 'Toutes',
      Filtre.aFaire: 'À faire',
      Filtre.faites: 'Faites',
      Filtre.enRetard: 'En retard',
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          for (final f in Filtre.values)
            ChoiceChip(
              label: Text(labels[f]!),
              selected: actuel == f,
              onSelected: (_) => ref.read(filtreProvider.notifier).choisir(f),
            ),
        ],
      ),
    );
  }

  Widget _buildList({required bool wide}) {
    final tasks = ref.watch(tachesFiltreesProvider);
    return Column(
      children: [
        _buildFiltres(),
        Expanded(
          child: tasks.isEmpty
              ? const Center(child: Text('Aucune tâche'))
              : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                selected: wide && _selectedId == task.id,
                leading: Icon(task.done
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked),
                title: Text(task.title),
                subtitle:
                Text('${task.course} · ${_formatDate(task.dueDate)}'),
                onTap: () {
                  if (wide) {
                    setState(() => _selectedId = task.id);
                  } else {
                    context.push('/echeances/${task.id}');
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailPane() {
    final tasks = ref.watch(tachesProvider);
    final matches = tasks.where((t) => t.id == _selectedId);
    if (matches.isEmpty) {
      return const Center(child: Text('Sélectionne une tâche'));
    }
    final task = matches.first;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DetailContent(
        task: task,
        onMarkDone: () =>
            ref.read(tachesProvider.notifier).marquerFait(task.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 840;
        return Scaffold(
          appBar: AppBar(title: const Text('Échéances')),
          body: wide
              ? Row(
            children: [
              SizedBox(width: 360, child: _buildList(wide: true)),
              const VerticalDivider(width: 1),
              Expanded(child: _buildDetailPane()),
            ],
          )
              : _buildList(wide: false),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('/echeances/nouvelle'),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}