/// A day in the user's life. Days start at `dayStartHour` local time
/// (04:00 by default) instead of midnight, so a goal ticked off at 1 a.m.
/// still counts for the evening before.
class AppDay implements Comparable<AppDay> {
  AppDay(this.year, this.month, this.day) {
    final check = DateTime.utc(year, month, day);
    if (check.year != year || check.month != month || check.day != day) {
      throw FormatException('Not a real date: $year-$month-$day');
    }
  }

  /// The app day that [moment] falls in.
  factory AppDay.of(DateTime moment, {int dayStartHour = 4}) {
    if (dayStartHour < 0 || dayStartHour > 23) {
      throw ArgumentError.value(dayStartHour, 'dayStartHour', 'must be 0–23');
    }
    final local = moment.toLocal();
    // Calendar arithmetic rather than Duration arithmetic, so a daylight
    // saving change can't shift the result by an hour.
    final date = local.hour < dayStartHour
        ? DateTime.utc(local.year, local.month, local.day - 1)
        : DateTime.utc(local.year, local.month, local.day);
    return AppDay(date.year, date.month, date.day);
  }

  /// Parses a `YYYY-MM-DD` key produced by [key].
  factory AppDay.parse(String key) {
    final match = _keyPattern.firstMatch(key);
    if (match == null) throw FormatException('Invalid AppDay key: $key');
    return AppDay(int.parse(match[1]!), int.parse(match[2]!), int.parse(match[3]!));
  }

  static final _keyPattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  final int year;
  final int month;
  final int day;

  /// Storage form, e.g. `2026-09-29`. Sorts correctly as a string.
  String get key => '${_pad(year, 4)}-${_pad(month, 2)}-${_pad(day, 2)}';

  /// 1 = Monday … 7 = Sunday.
  int get weekday => DateTime.utc(year, month, day).weekday;

  AppDay addDays(int days) {
    final d = DateTime.utc(year, month, day + days);
    return AppDay(d.year, d.month, d.day);
  }

  /// Whole days from this day to [other]; negative if [other] is earlier.
  int daysUntil(AppDay other) => DateTime.utc(other.year, other.month, other.day)
      .difference(DateTime.utc(year, month, day))
      .inDays;

  /// The local moment this app day begins.
  DateTime startsAt({int dayStartHour = 4}) => DateTime(year, month, day, dayStartHour);

  /// The local moment this app day ends: when the next one starts.
  DateTime endsAt({int dayStartHour = 4}) => addDays(1).startsAt(dayStartHour: dayStartHour);

  bool isBefore(AppDay other) => compareTo(other) < 0;

  bool isAfter(AppDay other) => compareTo(other) > 0;

  @override
  int compareTo(AppDay other) => key.compareTo(other.key);

  @override
  bool operator ==(Object other) => other is AppDay && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => key;

  static String _pad(int value, int width) => value.toString().padLeft(width, '0');
}
