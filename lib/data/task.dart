class Task {
  String? title;
  int? id;
  String? date;
  String? startTime, endTime, status,reminder, repeat;

  Task({
    required this.title,
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reminder,
    required this.repeat,
    required this.status,
  });
}
