import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/onboarding_repository.dart';

void main() {
  late AppDatabase db;
  late OnboardingRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = OnboardingRepository(db, FakeClock(DateTime(2026, 9, 30, 9)));
  });

  tearDown(() => db.close());

  test('stores text and multi-choice answers and reads them back typed', () async {
    await repo.saveAnswer('pet_name', 'Mochi');
    await repo.saveAnswer('focus_areas', ['move_more', 'rest_sleep']);
    final answers = await repo.answers();
    expect(answers['pet_name'], 'Mochi');
    expect(answers['focus_areas'], isA<List<String>>());
    expect(answers['focus_areas'], ['move_more', 'rest_sleep']);
  });

  test('saving again replaces the answer', () async {
    await repo.saveAnswer('get_up', 'easy');
    await repo.saveAnswer('get_up', 'hard');
    expect((await repo.answers())['get_up'], 'hard');
  });

  test('removes only the named answers', () async {
    await repo.saveAnswer('a', 'x');
    await repo.saveAnswer('b', 'y');
    await repo.removeAnswers(['a']);
    await repo.removeAnswers([]);
    expect((await repo.answers()).keys, ['b']);
  });
}
