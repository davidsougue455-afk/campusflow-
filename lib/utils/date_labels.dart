import 'package:intl/intl.dart';

const _jours = ['lun.', 'mar.', 'mer.', 'jeu.', 'ven.', 'sam.', 'dim.'];

String dueLabel(DateTime due, {required bool done}) {
  final now = DateTime.now();
  if (done) return DateFormat('dd/MM/yyyy').format(due);
  if (due.isBefore(now)) {
    return 'En retard · ${DateFormat('dd/MM').format(due)}';
  }
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(due.year, due.month, due.day);
  final diff = day.difference(today).inDays;
  final hour = DateFormat('HH:mm').format(due);
  if (diff == 0) return "Aujourd'hui · $hour";
  if (diff == 1) return 'Demain · $hour';
  if (diff < 7) return '${_jours[due.weekday - 1]} · $hour';
  return '${DateFormat('dd/MM').format(due)} · $hour';
}