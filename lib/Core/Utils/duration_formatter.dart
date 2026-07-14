/// Formats second counts for display, e.g. 45 -> "45 sec", 90 -> "1 min 30 sec".
class DurationFormatter {
  DurationFormatter._();

  static String formatSeconds(int totalSeconds) {
    if (totalSeconds < 60) {
      return '$totalSeconds sec';
    }
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    if (seconds == 0) {
      return '$minutes min';
    }
    return '$minutes min $seconds sec';
  }
}
