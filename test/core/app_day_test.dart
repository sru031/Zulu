import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/core/app_day.dart';

void main() {
  group('AppDay.of', () {
    test('a moment before the day-start hour belongs to the previous day', () {
      expect(AppDay.of(DateTime(2026, 9, 29, 3, 59)), AppDay(2026, 9, 28));
    });

    test('the day-start hour itself begins the new day', () {
      expect(AppDay.of(DateTime(2026, 9, 29, 4)), AppDay(2026, 9, 29));
    });

    test('respects a custom day-start hour', () {
      expect(AppDay.of(DateTime(2026, 9, 29, 0, 30), dayStartHour: 0), AppDay(2026, 9, 29));
      expect(AppDay.of(DateTime(2026, 9, 29, 5, 59), dayStartHour: 6), AppDay(2026, 9, 28));
    });

    test('rolls back across month and year boundaries', () {
      expect(AppDay.of(DateTime(2026, 1, 1, 2)), AppDay(2025, 12, 31));
      expect(AppDay.of(DateTime(2026, 3, 1, 1)), AppDay(2026, 2, 28));
    });

    test('rejects an out-of-range day-start hour', () {
      expect(() => AppDay.of(DateTime(2026), dayStartHour: 24), throwsArgumentError);
    });
  });

  group('keys', () {
    test('formats with zero padding and parses back', () {
      final day = AppDay(2026, 3, 7);
      expect(day.key, '2026-03-07');
      expect(AppDay.parse('2026-03-07'), day);
    });

    test('rejects malformed and impossible dates', () {
      expect(() => AppDay.parse('2026-3-7'), throwsFormatException);
      expect(() => AppDay.parse('hello'), throwsFormatException);
      expect(() => AppDay.parse('2026-02-30'), throwsFormatException);
    });
  });

  group('arithmetic', () {
    test('addDays crosses month ends', () {
      expect(AppDay(2026, 9, 30).addDays(1), AppDay(2026, 10, 1));
      expect(AppDay(2026, 3, 1).addDays(-1), AppDay(2026, 2, 28));
    });

    test('daysUntil counts whole days in both directions', () {
      expect(AppDay(2026, 9, 1).daysUntil(AppDay(2026, 10, 1)), 30);
      expect(AppDay(2026, 10, 1).daysUntil(AppDay(2026, 9, 1)), -30);
    });

    test('weekday is ISO (Monday = 1)', () {
      expect(AppDay(2026, 9, 29).weekday, DateTime.tuesday);
    });

    test('ends when the next day starts', () {
      final day = AppDay(2026, 9, 29);
      expect(day.startsAt(), DateTime(2026, 9, 29, 4));
      expect(day.endsAt(), DateTime(2026, 9, 30, 4));
    });

    test('orders chronologically', () {
      final days = [AppDay(2026, 10, 1), AppDay(2025, 12, 31), AppDay(2026, 9, 29)]..sort();
      expect(days.map((d) => d.key), ['2025-12-31', '2026-09-29', '2026-10-01']);
      expect(AppDay(2026, 1, 1).isBefore(AppDay(2026, 1, 2)), isTrue);
      expect(AppDay(2026, 1, 2).isAfter(AppDay(2026, 1, 1)), isTrue);
    });
  });
}
