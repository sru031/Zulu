import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/app/providers.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/content/onboarding_script.dart';
import 'package:zulu/core/clock.dart';
import 'package:zulu/data/db/database.dart';
import 'package:zulu/data/repositories/profile_repository.dart';
import 'package:zulu/features/onboarding/onboarding_controller.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../../helpers/read_file.dart';

void main() {
  late ContentBundle content;
  late ThemeKit kit;
  late AppDatabase db;
  late ProviderContainer container;

  setUpAll(() async {
    content = await loadContent(readFile);
    kit = await loadThemeKit(readFile);
  });

  ProviderContainer makeContainer() => ProviderContainer.test(overrides: [
        databaseProvider.overrideWithValue(db),
        contentProvider.overrideWithValue(content),
        themeKitProvider.overrideWithValue(kit),
        clockProvider.overrideWithValue(FakeClock(DateTime(2026, 9, 30, 10))),
      ]);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await ProfileRepository(db, FakeClock(DateTime(2026, 9, 30))).ensure();
    container = makeContainer();
  });

  tearDown(() => db.close());

  OnboardingController controller() => container.read(onboardingControllerProvider.notifier);
  Future<OnboardingState> state() => container.read(onboardingControllerProvider.future);

  /// Answers every step until the plan, using [choices] where given and a
  /// sensible default otherwise.
  Future<void> answerAll(Map<String, Object> choices) async {
    for (var s = await state(); !s.onPlan; s = await state()) {
      final step = s.step!;
      final Object value = choices[step.id] ??
          switch (step.type) {
            StepType.multi => [step.options.first.id],
            StepType.single || StepType.talkChoice => step.options.first.id,
            StepType.egg => 'mint',
            StepType.text => 'Mochi',
            StepType.time => step.defaultValue!,
            _ => 'ok',
          };
      await controller().answer(value);
    }
  }

  test('starts at the welcome step', () async {
    expect((await state()).step!.id, 'welcome');
  });

  test('saves each answer and moves on', () async {
    await controller().answer('ok');
    expect((await state()).step!.id, 'egg');
    await controller().answer('mint');
    expect((await state()).answers['egg'], 'mint');
    expect((await state()).step!.id, 'hatch');
  });

  test('resumes at the first unanswered step', () async {
    await controller().answer('ok');
    await controller().answer('mint');
    container.dispose();
    container = makeContainer();
    expect((await state()).step!.id, 'hatch');
  });

  test('back returns to the previous visible step, keeping answers', () async {
    await controller().answer('ok');
    await controller().answer('mint');
    expect(controller().canGoBack, isTrue);
    controller().back();
    expect((await state()).step!.id, 'egg');
    expect((await state()).answers['egg'], 'mint');
  });

  test('changing an answer drops follow-ups that no longer apply', () async {
    await answerAll({'focus_areas': ['move_more'], 'move_blocker': ['no_time']});
    expect((await state()).answers.containsKey('move_blocker'), isTrue);
    controller().back();
    controller().back();
    expect((await state()).step!.id, 'focus_areas');
    await controller().answer(['rest_sleep']);
    final s = await state();
    expect(s.answers.containsKey('move_blocker'), isFalse);
    expect(s.step!.id, 'rest_blocker');
  });

  test('reaches an explained plan after the last question', () async {
    await answerAll({'hard_lately': ['stress'], 'focus_areas': ['move_more'], 'move_blocker': ['no_time']});
    final s = await state();
    expect(s.onPlan, isTrue);
    expect(s.plan!.map((p) => p.goal.id), containsAllInOrder(['get_out_of_bed', 'drink_water', 'three_breaths']));
    expect(s.plan!.length, lessThanOrEqualTo(7));
  });

  test('the plan keeps at least one goal', () async {
    await answerAll({});
    for (final p in [...(await state()).plan!]) {
      controller().removeFromPlan(p.goal.id);
    }
    expect((await state()).plan, hasLength(1));
  });

  test('swapping replaces a goal in place and keeps its reason', () async {
    await answerAll({'focus_areas': ['move_more']});
    final before = (await state()).plan!;
    final target = before.last;
    final replacement = controller().alternativesFor(target.goal.id).first;
    controller().swapInPlan(target.goal.id, replacement);
    final after = (await state()).plan!;
    expect(after.last.goal.id, replacement.id);
    expect(after.last.reason, target.reason);
    expect(after.length, before.length);
  });

  test('accepting the plan saves the pet, the profile and the goals', () async {
    await answerAll({'pet_name': 'Mochi', 'user_name': 'Sam', 'focus_areas': ['connect']});
    await controller().acceptPlan();
    final pet = await db.select(db.pets).getSingle();
    expect(pet.name, 'Mochi');
    final profile = await db.select(db.profiles).getSingle();
    expect(profile.userName, 'Sam');
    expect(profile.onboardingDoneAt, isNotNull);
    expect(await db.select(db.goals).get(), hasLength((await state()).plan!.length));
  });

  test('template vars use the answers so far', () async {
    await answerAll({'pet_name': 'Mochi', 'user_name': ''});
    expect(controller().vars['petName'], 'Mochi');
    expect(controller().vars['userName'], 'friend');
  });
}
