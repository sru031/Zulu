import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/content/onboarding_script.dart';
import 'package:zulu/features/onboarding/ui/step_views.dart';
import 'package:zulu/shared/services/reminder_permission.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../../helpers/read_file.dart';
import '../../helpers/test_app.dart';

class FakePermission implements ReminderPermission {
  int calls = 0;

  @override
  Future<bool> request() async {
    calls++;
    return true;
  }
}

OnboardingStep step(String json) =>
    OnboardingScript.fromJson(JsonReader.decode('o.json', '{"sections":[],"steps":[$json,'
            '{"id":"areas","type":"multi","prompt":"?","options":[{"id":"a","label":"A"},{"id":"b","label":"B"}]}],'
            '"foundationGoals":[],"foundationReason":"r","focusQuestion":"areas","planRules":[]}'))
        .steps
        .first;

void main() {
  late ThemeKit kit;
  final answers = <Object>[];

  setUpAll(() async => kit = await loadThemeKit(readFile));
  setUp(answers.clear);

  Future<void> show(WidgetTester tester, OnboardingStep s, {Object? initial, FakePermission? permission}) => pumpInApp(
        tester,
        StepView(step: s, vars: const {'petName': 'Pip', 'userName': 'Sam'}, initial: initial, onAnswer: answers.add),
        kit: kit,
        overrides: [if (permission != null) reminderPermissionProvider.overrideWithValue(permission)],
      );

  testWidgets('talk shows the filled prompt and continues', (tester) async {
    await show(tester, step('{"id":"t","type":"talk","prompt":"Hi {userName}!","button":"Okay"}'));
    expect(find.text('Hi Sam!'), findsOneWidget);
    await tester.tap(find.text('Okay'));
    expect(answers, ['ok']);
  });

  testWidgets('single choice highlights and auto-advances', (tester) async {
    await show(tester, step('{"id":"s","type":"single","prompt":"Pick","options":[{"id":"a","label":"Apple","icon":"🍎"},{"id":"b","label":"Berry"}]}'));
    await tester.tap(find.text('Berry'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(answers, isEmpty);
    await tester.pump(autoAdvanceDelay);
    expect(answers, ['b']);
  });

  testWidgets('multi choice needs a pick before Next', (tester) async {
    await show(tester, step('{"id":"m","type":"multi","prompt":"Pick","options":[{"id":"a","label":"Apple"},{"id":"b","label":"Berry"}]}'));
    await tester.tap(find.text('Next'));
    expect(answers, isEmpty);
    await tester.tap(find.text('Apple'));
    await tester.tap(find.text('Berry'));
    await tester.tap(find.text('Apple'));
    await tester.pump();
    await tester.tap(find.text('Next'));
    expect(answers, [['b']]);
  });

  testWidgets('multi choice starts from an earlier answer', (tester) async {
    await show(tester, step('{"id":"m","type":"multi","prompt":"Pick","options":[{"id":"a","label":"Apple"},{"id":"b","label":"Berry"}]}'), initial: ['a']);
    await tester.tap(find.text('Next'));
    expect(answers, [['a']]);
  });

  testWidgets('text needs a value unless skippable, and shuffles suggestions', (tester) async {
    await show(tester, step('{"id":"n","type":"text","prompt":"Name?","placeholder":"Pet name","suggestions":["Pip","Bean"]}'));
    await tester.tap(find.byTooltip('Suggest a name'));
    await tester.pump();
    expect(find.widgetWithText(TextField, 'Pip'), findsOneWidget);
    await tester.tap(find.byTooltip('Suggest a name'));
    await tester.pump();
    await tester.tap(find.text('Next'));
    expect(answers, ['Bean']);
  });

  testWidgets('a skippable text step can be skipped', (tester) async {
    await show(tester, step('{"id":"u","type":"text","prompt":"You?","skippable":true}'));
    await tester.tap(find.text('Skip'));
    expect(answers, ['']);
  });

  testWidgets('time continues with the default', (tester) async {
    await show(tester, step('{"id":"w","type":"time","prompt":"Wake?","default":"07:30"}'));
    expect(find.text('7:30 AM'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    expect(answers, ['07:30']);
  });

  testWidgets('egg picks one of the theme eggs', (tester) async {
    await show(tester, step('{"id":"e","type":"egg","prompt":"Pick an egg","button":"Hatch this egg"}'));
    await tester.tap(find.bySemanticsLabel('mint egg'));
    await tester.pump();
    await tester.tap(find.text('Hatch this egg'));
    expect(answers, ['mint']);
  });

  testWidgets('hatch shows the button after the hatching effect', (tester) async {
    await show(tester, step('{"id":"h","type":"hatch","prompt":"Hatching!","button":"Say hello"}'));
    expect(find.text('Say hello'), findsNothing);
    await tester.pump(hatchDelay);
    await tester.pump();
    await tester.tap(find.text('Say hello'));
    expect(answers, ['ok']);
  });

  testWidgets('permission asks the system, or can wait', (tester) async {
    final permission = FakePermission();
    await show(tester, step('{"id":"r","type":"permission","prompt":"Nudges?","preview":"{petName}: water?"}'), permission: permission);
    expect(find.text('Pip: water?'), findsOneWidget);
    await tester.tap(find.text('Turn on reminders'));
    await tester.pumpAndSettle();
    expect(permission.calls, 1);
    expect(answers, ['granted']);
  });

  testWidgets('permission "Maybe later" skips the system prompt', (tester) async {
    final permission = FakePermission();
    await show(tester, step('{"id":"r","type":"permission","prompt":"Nudges?"}'), permission: permission);
    await tester.tap(find.text('Maybe later'));
    expect(permission.calls, 0);
    expect(answers, ['later']);
  });
}
