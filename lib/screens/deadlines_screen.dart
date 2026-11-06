import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/tasks_provider.dart';
import '../widgets/task_card.dart';
import 'detail_screen.dart';

class DeadlinesScreen extends ConsumerStatefulWidget {
  const DeadlinesScreen({super.key});

  @override
  ConsumerState<DeadlinesScreen> createState() => _DeadlinesScreenState();
}

class _DeadlinesScreenState extends ConsumerState<DeadlinesScreen> {
  String? _selectedId;

  Widget _buildSummary() {
    final tasks = ref.watch(tachesProvider);
    final now = DateTime.now();
    final aFaire = tasks.where((t) => !t.done).length;
    final enRetard =
        tasks.where((t) => !t.done && t.dueDate.isBefore(now)).length;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(child: _Stat(value: '$aFaire', label: 'à faire')),
          Container(width: 1, height: 40, color: Colors.white30),
          Expanded(child: _Stat(value: '$enRetard', label: 'en retard')),
        ],
      ),
    );
  }

  Widget _buildFiltres() {
    final actuel = ref.watch(filtreProvider);
    const labels = {
      Filtre.toutes: 'Toutes',
      Filtre.aFaire: 'À faire',
      Filtre.faites: 'Faites',
      Filtre.enRetard: 'En retard',
    };
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (final f in Filtre.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(labels[f]!),
                selected: actuel == f,
                onSelected: (_) => ref.read(filtreProvider.notifier).choisir(f),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildList({required bool wide}) {
    final tasks = ref.watch(tachesFiltreesProvider);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        _buildSummary(),
        _buildFiltres(),
        Expanded(
          child: tasks.isEmpty
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.task_alt, size: 56, color: scheme.outline),
                const SizedBox(height: 12),
                Text(
                  'Aucune tâche ici',
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                task: task,
                selected: wide && _selectedId == task.id,
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
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.touch_app_outlined,
                size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            const Text('Sélectionne une tâche'),
          ],
        ),
      );
    }
    final task = matches.first;
    return Padding(
      padding: const EdgeInsets.all(24),
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
              SizedBox(width: 420, child: _buildList(wide: true)),
              const VerticalDivider(width: 1),
              Expanded(child: _buildDetailPane()),
            ],
          )
              : _buildList(wide: false),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push('/echeances/nouvelle'),
            icon: const Icon(Icons.add),
            label: const Text('Nouvelle tâche'),
          ),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}