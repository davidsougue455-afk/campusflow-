class Task {
  final String id;
  final String title;
  final String course;
  final DateTime dueDate;
  final bool done;

  const Task({
    required this.id,
    required this.title,
    required this.course,
    required this.dueDate,
    this.done = false,
  });

  Task copyWith({String? title, String? course, DateTime? dueDate, bool? done}) {
    return Task(
      id: id,
      title: title ?? this.title,
      course: course ?? this.course,
      dueDate: dueDate ?? this.dueDate,
      done: done ?? this.done,
    );
  }
}