import 'package:flutter/material.dart';
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

  final List<Task> _tasks = [
    Task(id: '1', title: 'Rendre le TP Flutter', course: 'Développement mobile', dueDate: DateTime(2026, 11, 12)),
    Task(id: '2', title: 'Exposé PDH / SDH', course: 'Télécoms', dueDate: DateTime(2026, 11, 15)),
    Task(id: '3', title: 'Rapport de TP réseaux', course: 'Réseaux', dueDate: DateTime(2026, 11, 20), done: true),
  ];

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Échéances')),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            leading: Icon(task.done ? Icons.check_circle : Icons.radio_button_unchecked),
            title: Text(task.title),
            subtitle: Text('${task.course} · ${_formatDate(task.dueDate)}'),
            onTap: () async {
              final updated = await Navigator.push<Task>(
                context,
                MaterialPageRoute(builder: (_) => DetailScreen(task: task)),
              );
              if (updated != null) {
                setState(() => _tasks[index] = updated);
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push<Task>(
            context,
            MaterialPageRoute(builder: (_) => const FormScreen()),
          );
          if (newTask != null) {
            setState(() => _tasks.add(newTask));
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: 'Échéances'),
          NavigationDestination(icon: Icon(Icons.school), label: 'Cours'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}