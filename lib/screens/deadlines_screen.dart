
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

class DeadlinesScreen extends StatefulWidget {
  const DeadlinesScreen({super.key});

  @override
  State<DeadlinesScreen> createState() => _DeadlinesScreenState();
}

class _DeadlinesScreenState extends State<DeadlinesScreen> {
  int _selectedIndex = 0;
  int? _selectedTaskIndex;

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Rendre le TP Flutter',
      course: 'Développement mobile',
      dueDate: DateTime(2026, 11, 12),
    ),
    Task(
      id: '2',
      title: 'Exposé PDH / SDH',
      course: 'Télécoms',
      dueDate: DateTime(2026, 11, 15),
    ),
    Task(
      id: '3',
      title: 'Rapport de TP réseaux',
      course: 'Réseaux',
      dueDate: DateTime(2026, 11, 20),
      done: true,
    ),
  ];

  String _formatDate(DateTime d) {
    return DateFormat('dd/MM/yyyy').format(d);
  }

  Widget _buildList({required bool wide}) {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];

        return ListTile(
          selected: wide && _selectedTaskIndex == index,
          leading: Icon(
            task.done
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: task.done ? Colors.green : Colors.grey,
          ),
          title: Text(task.title),
          subtitle: Text(
            '${task.course} · ${_formatDate(task.dueDate)}',
          ),
          onTap: () async {
            if (wide) {
              setState(() {
                _selectedTaskIndex = index;
              });
            } else {
              final updated = await Navigator.push<Task>(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(task: task),
                ),
              );

              if (updated != null && mounted) {
                setState(() {
                  _tasks[index] = updated;
                });
              }
            }
          },
        );
      },
    );
  }

  Widget _buildDetailPane() {
    final i = _selectedTaskIndex;

    if (i == null) {
      return const Center(
        child: Text('Sélectionne une tâche'),
      );
    }

    final task = _tasks[i];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DetailContent(
        task: task,
        onMarkDone: () {
          setState(() {
            _tasks[i] = task.copyWith(done: true);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 840;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Échéances'),
          ),
          body: wide
              ? Row(
            children: [
              SizedBox(
                width: 360,
                child: _buildList(wide: true),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _buildDetailPane(),
              ),
            ],
          )
              : _buildList(wide: false),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final newTask = await Navigator.push<Task>(
                context,
                MaterialPageRoute(
                  builder: (_) => const FormScreen(),
                ),
              );

              if (newTask != null && mounted) {
                setState(() {
                  _tasks.add(newTask);
                });
              }
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) {
              setState(() {
                _selectedIndex = i;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.event),
                label: 'Échéances',
              ),
              NavigationDestination(
                icon: Icon(Icons.school),
                label: 'Cours',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }
}
