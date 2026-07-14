/// Part of the day used to pick a greeting, kept as a pure function so the
/// header widget stays free of time logic.
enum Daypart {
  morning,
  afternoon,
  evening;

  static Daypart of(DateTime time) {
    if (time.hour < 12) {
      return Daypart.morning;
    }
    if (time.hour < 17) {
      return Daypart.afternoon;
    }
    return Daypart.evening;
  }
}

/// Tiny offline date formatter (no intl dependency needed for one label).
class DateLabels {
  DateLabels._();

  static const List<String> _weekdays = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> _months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// e.g. `Tue, Jul 14`.
  static String short(DateTime date) {
    return '${_weekdays[date.weekday - 1]}, '
        '${_months[date.month - 1]} ${date.day}';
  }
}
