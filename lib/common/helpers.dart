String secondsToHRF(double totalSeconds) {
  int minutes = (totalSeconds / 60).floor();
  int seconds = (totalSeconds % 60).round();

  // Adjusting for the case when seconds equal 60
  if (seconds == 60) {
    minutes++;
    seconds = 0;
  }

  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = seconds.toString().padLeft(2, '0');

  return '$minutesStr:$secondsStr';
}

/// Converts a timestamp to a human-readable time format.
///
/// Example:
/// ```dart
/// String result = TimeFormatter.timestampToHRF(1641500000);
/// print(result); // Output: 'Monday, 10.01.2022 - 14:46'
/// ```
String timestampToHRF(double timestamp) {
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).round());

  String dayOfWeek = _getDayOfWeek(dateTime.weekday);
  String formattedDate = _formatDate(dateTime);
  String formattedTime = _formatTime(dateTime);

  return '$dayOfWeek, $formattedDate - $formattedTime';
}

/// Converts a [DateTime] object to a formatted string.
///
/// Example:
/// ```dart
/// DateTime date = DateTime.now();
/// String result = TimeFormatter.dateToFormattedString(date);
/// print(result); // Output: 'Monday, 10.01.2022 - 14:46'
/// ```
String dateToFormattedString(DateTime date) {
  String dayOfWeek = _getDayOfWeek(date.weekday);
  String formattedDate = _formatDate(date);
  String formattedTime = _formatTime(date);

  return '$dayOfWeek, $formattedDate - $formattedTime';
}

/// Converts total seconds to a human-readable time format (HH:MM).
///
/// Example:
/// ```dart
/// String result = TimeFormatter.secondsToHRF(125.5);
/// print(result); // Output: '02:05'
/// ```
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
