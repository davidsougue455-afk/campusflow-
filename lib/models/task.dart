class Task {
  final String id;
  final String title;
  final String course;
  final DateTime dueDate;
  final bool done;
  final String description;
  final bool reminder;

  const Task({
    required this.id,
    required this.title,
    required this.course,
    required this.dueDate,
    this.done = false,
    this.description = '',
    this.reminder = false,
  });

  Task copyWith({
    String? title,
    String? course,
    DateTime? dueDate,
    bool? done,
    String? description,
    bool? reminder,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      course: course ?? this.course,
      dueDate: dueDate ?? this.dueDate,
      done: done ?? this.done,
      description: description ?? this.description,
      reminder: reminder ?? this.reminder,
    );
  }
}