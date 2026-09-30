import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/core/clock.dart';

void main() {
  test('FakeClock returns the time it was given and can move', () {
    final clock = FakeClock(DateTime(2026, 9, 29, 9));
    expect(clock.now(), DateTime(2026, 9, 29, 9));
    clock.advance(const Duration(hours: 2));
    expect(clock.now(), DateTime(2026, 9, 29, 11));
    clock.set(DateTime(2027));
    expect(clock.now(), DateTime(2027));
  });

  test('SystemClock is close to DateTime.now()', () {
    final difference = const SystemClock().now().difference(DateTime.now()).abs();
    expect(difference, lessThan(const Duration(seconds: 1)));
  });
}
