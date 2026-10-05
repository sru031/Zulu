import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/core/app_day.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/day_repository.dart';
import 'package:zulu/data/repositories/wallet_repository.dart';

void main() {
  late AppDatabase db;
  late DayRepository days;
  late WalletRepository wallet;
  final today = AppDay(2026, 10, 5);
  final yesterday = AppDay(2026, 10, 4);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    final clock = FakeClock(DateTime(2026, 10, 5, 9));
    days = DayRepository(db, clock);
    wallet = WalletRepository(db, clock);
  });

  tearDown(() => db.close());

  test('counts completions per goal and returns which completion this is', () async {
    expect(await days.addCompletion(1, today), 1);
    expect(await days.addCompletion(1, today), 2);
    expect(await days.addCompletion(2, today), 1);
    expect(await days.addCompletion(1, yesterday), 1);
    expect(await days.completionCounts(today), {1: 2, 2: 1});
  });

  test('undo removes only the latest completion of that goal today', () async {
    await days.addCompletion(1, today);
    await days.addCompletion(1, today);
    expect(await days.removeLatestCompletion(1, today), isTrue);
    expect(await days.completionCounts(today), {1: 1});
    expect(await days.removeLatestCompletion(2, today), isFalse);
  });

  test('skips are per goal per day and can be undone', () async {
    await days.skip(3, today);
    await days.skip(3, today);
    expect(await days.skipped(today), {3});
    expect(await days.skipped(yesterday), isEmpty);
    await days.unskip(3, today);
    expect(await days.skipped(today), isEmpty);
  });

  test('a day starts with no low-energy mode, adventure or gift', () async {
    final day = await days.day(today);
    expect(day.lowEnergy, isFalse);
    expect(day.adventureStartedAt, isNull);
    expect(day.surpriseGiven, isFalse);
  });

  test('records the adventure, the claim and the surprise for a day', () async {
    await days.setLowEnergy(today, true);
    await days.startAdventure(today, start: DateTime(2026, 10, 5, 10), endsAt: DateTime(2026, 10, 5, 16), storyId: 'kite_day');
    await days.markSurprise(today);
    var day = await days.day(today);
    expect(day.lowEnergy, isTrue);
    expect(day.storyId, 'kite_day');
    expect(day.adventureEndsAt!.isAtSameMomentAs(DateTime(2026, 10, 5, 16)), isTrue);
    expect(day.surpriseGiven, isTrue);
    expect(await days.adventuresClaimed(), 0);
    await days.claimAdventure(today);
    day = await days.day(today);
    expect(day.adventureClaimed, isTrue);
    expect(await days.adventuresClaimed(), 1);
  });

  test('lists earlier days with check-offs, oldest first', () async {
    await days.addCompletion(1, AppDay(2026, 10, 3));
    await days.addCompletion(1, yesterday);
    await days.addCompletion(2, yesterday);
    await days.addCompletion(1, today);
    expect(await days.activeDaysBefore(today), [AppDay(2026, 10, 3), yesterday]);
  });

  test('days showed up counts distinct days with any check-off', () async {
    await days.addCompletion(1, yesterday);
    await days.addCompletion(1, today);
    await days.addCompletion(2, today);
    expect(await days.daysShowedUp(), 2);
  });

  test('the wallet balance is the sum of its entries', () async {
    expect(await wallet.balance(), 0);
    await wallet.add(3, 'goal', refId: '1');
    await wallet.add(20, 'adventure');
    await wallet.add(-3, 'goal_undo', refId: '1');
    expect(await wallet.balance(), 20);
  });
}
