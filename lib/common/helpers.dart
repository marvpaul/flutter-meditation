String secondsToHRF(double totalSeconds) {
    int minutes = (totalSeconds / 60).floor();
    int seconds = (totalSeconds % 60).round();

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

String timestampToHRF(double timestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).round());

  String dayOfWeek = _getDayOfWeek(dateTime.weekday);
  String formattedDate = _formatDate(dateTime);
  String formattedTime = _formatTime(dateTime);

  return '$dayOfWeek, $formattedDate - $formattedTime';
}

String _getDayOfWeek(int day) {
  switch (day) {
    case DateTime.monday:
      return 'Monday';
    case DateTime.tuesday:
      return 'Tuesday';
    case DateTime.wednesday:
      return 'Wednesday';
    case DateTime.thursday:
      return 'Thursday';
    case DateTime.friday:
      return 'Friday';
    case DateTime.saturday:
      return 'Saturday';
    case DateTime.sunday:
      return 'Sunday';
    default:
      return '';
  }
}

String _formatDate(DateTime dateTime) {
  String day = dateTime.day.toString().padLeft(2, '0');
  String month = dateTime.month.toString().padLeft(2, '0');
  String year = dateTime.year.toString();
  return '$day.$month.$year';
}

String _formatTime(DateTime dateTime) {
  String hour = dateTime.hour.toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}