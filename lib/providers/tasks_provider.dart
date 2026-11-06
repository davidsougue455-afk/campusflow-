import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

class TachesNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() => [
    Task(id: '1', title: 'Rendre le TP Flutter', course: 'Développement mobile', dueDate: DateTime(2026, 11, 12)),
    Task(id: '2', title: 'Exposé PDH / SDH', course: 'Télécoms', dueDate: DateTime(2026, 11, 15)),
    Task(id: '3', title: 'Rapport de TP réseaux', course: 'Réseaux', dueDate: DateTime(2026, 11, 20), done: true),
    Task(id: '4', title: 'Lire le chapitre 3', course: 'Systèmes', dueDate: DateTime(2026, 11, 1)),
  ];

  void ajouter({
    required String title,
    required String course,
    required DateTime dueDate,
  }) {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      course: course,
      dueDate: dueDate,
    );
    state = [...state, task];
  }

  void marquerFait(String id) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(done: true) else t,
    ];
  }
}

final tachesProvider =
NotifierProvider<TachesNotifier, List<Task>>(TachesNotifier.new);