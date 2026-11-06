import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

class TachesNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() => [
    Task(
      id: '1',
      title: 'Projet Flutter',
      course: 'Développement mobile',
      dueDate: DateTime(2026, 11, 13, 17, 0),
      description: 'Rendre le dépôt GitHub avec les ateliers 1 à 4.',
      reminder: true,
    ),
    Task(
      id: '2',
      title: 'Rendu TP Dart',
      course: 'Développement mobile',
      dueDate: DateTime(2026, 11, 7, 12, 0),
    ),
    Task(
      id: '3',
      title: 'Rapport de TP réseaux',
      course: 'Réseaux',
      dueDate: DateTime(2026, 11, 20, 8, 0),
      done: true,
    ),
    Task(
      id: '4',
      title: 'Lire le chapitre 3',
      course: 'Systèmes',
      dueDate: DateTime(2026, 11, 1, 18, 0),
    ),
  ];

  void ajouter({
    required String title,
    required String course,
    required DateTime dueDate,
    String description = '',
    bool reminder = false,
  }) {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      course: course,
      dueDate: dueDate,
      description: description,
      reminder: reminder,
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

enum Filtre { toutes, aFaire, faites, enRetard }

class FiltreNotifier extends Notifier<Filtre> {
  @override
  Filtre build() => Filtre.toutes;

  void choisir(Filtre f) => state = f;
}

final filtreProvider =
NotifierProvider<FiltreNotifier, Filtre>(FiltreNotifier.new);

final tachesFiltreesProvider = Provider<List<Task>>((ref) {
  final taches = ref.watch(tachesProvider);
  final filtre = ref.watch(filtreProvider);
  final maintenant = DateTime.now();
  switch (filtre) {
    case Filtre.toutes:
      return taches;
    case Filtre.aFaire:
      return taches.where((t) => !t.done).toList();
    case Filtre.faites:
      return taches.where((t) => t.done).toList();
    case Filtre.enRetard:
      return taches
          .where((t) => !t.done && t.dueDate.isBefore(maintenant))
          .toList();
  }
});