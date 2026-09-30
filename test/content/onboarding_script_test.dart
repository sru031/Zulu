import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/content/onboarding_script.dart';
import 'package:zulu/domain/pet/trait.dart';

Matcher failsAt(String path) =>
    throwsA(isA<ContentFormatException>().having((e) => e.path, 'path', path));

const _sections = '"sections":[{"id":"x","label":"X"}]';
const _tail = '"foundationGoals":["g"],"foundationReason":"why","focusQuestion":"areas","planRules":[]';
const _areas = '{"id":"areas","type":"multi","prompt":"Help?","section":"x",'
    '"options":[{"id":"a","label":"A"},{"id":"b","label":"B"}]}';

OnboardingScript parse(String steps, {String tail = _tail}) =>
    OnboardingScript.fromJson(JsonReader.decode('o.json', '{$_sections,"steps":[$steps],$tail}'));

void main() {
  test('parses steps, options, conditions and rules', () {
    final script = parse(
      '{"id":"hi","type":"talk","prompt":"Hello {userName}","button":"Okay"},'
      '{"id":"mood","type":"talk_choice","prompt":"Pick","options":[{"id":"p","label":"P","trait":"calm","nudge":2},{"id":"q","label":"Q"}]},'
      '$_areas,'
      '{"id":"follow","type":"single","prompt":"More?","section":"x","showIf":{"question":"areas","includes":"a"},'
      '"options":[{"id":"y","label":"Y"},{"id":"n","label":"N"}]}',
      tail: '"foundationGoals":["g"],"foundationReason":"why","focusQuestion":"areas",'
          '"planRules":[{"when":{"question":"follow","equals":"y"},"add":["g2"],"reason":"you said yes"}]',
    );
    expect(script.steps.map((s) => s.id), ['hi', 'mood', 'areas', 'follow']);
    expect(script.step('hi')!.button, 'Okay');
    expect(script.step('mood')!.type, StepType.talkChoice);
    expect(script.step('mood')!.option('p')!.trait, Trait.calm);
    expect(script.step('mood')!.option('p')!.nudge, 2);
    expect(script.step('mood')!.option('q')!.nudge, 1);
    expect(script.step('follow')!.showIf!.matches({'areas': ['a']}), isTrue);
    expect(script.planRules.single.add, ['g2']);
    expect(script.indexOf('areas'), 2);
    expect(script.texts.map((t) => t.$2), containsAll(['Hello {userName}', 'you said yes', 'why', 'A']));
  });

  test('conditions: equals, includes, includesAny, not, and missing answers', () {
    const eq = Condition(question: 'q', op: ConditionOp.equals, values: ['hard']);
    const inc = Condition(question: 'm', op: ConditionOp.includes, values: ['a']);
    const any = Condition(question: 'm', op: ConditionOp.includesAny, values: ['x', 'b']);
    const not = Condition(question: 'q', op: ConditionOp.equals, values: ['hard'], negate: true);
    final answers = {'q': 'hard', 'm': ['a', 'b']};
    expect(eq.matches(answers), isTrue);
    expect(eq.matches({'q': 'easy'}), isFalse);
    expect(inc.matches(answers), isTrue);
    expect(inc.matches({'m': ['b']}), isFalse);
    expect(any.matches(answers), isTrue);
    expect(any.matches({'m': ['c']}), isFalse);
    expect(not.matches(answers), isFalse);
    expect(eq.matches({}), isFalse);
    expect(not.matches({}), isTrue);
  });

  test('rejects a showIf that points at a later step', () {
    expect(
      () => parse('{"id":"follow","type":"talk","prompt":"?","showIf":{"question":"areas","includes":"a"}},$_areas'),
      failsAt(r'$.steps[0].showIf.question'),
    );
  });

  test('rejects a condition value that is not an option', () {
    expect(
      () => parse('$_areas,{"id":"f","type":"talk","prompt":"?","showIf":{"question":"areas","includes":"zzz"}}'),
      failsAt(r'$.steps[1].showIf'),
    );
  });

  test('rejects pronoun options other than she, he and they', () {
    expect(
      () => parse('{"id":"p","type":"single","prompt":"?","saveTo":"pet.pronouns",'
          '"options":[{"id":"she","label":"She"},{"id":"xe","label":"Xe"}]},$_areas'),
      failsAt(r'$.steps[0].options'),
    );
  });

  test('rejects a saveTo on the wrong step type', () {
    expect(
      () => parse('{"id":"n","type":"talk","prompt":"?","saveTo":"pet.name"},$_areas'),
      failsAt(r'$.steps[0].saveTo'),
    );
  });

  test('rejects a choice step with fewer than two options', () {
    expect(
      () => parse('{"id":"s","type":"single","prompt":"?","options":[{"id":"a","label":"A"}]},$_areas'),
      failsAt(r'$.steps[0].type'),
    );
  });

  test('rejects a malformed time default', () {
    expect(
      () => parse('{"id":"t","type":"time","prompt":"?","default":"7:30"},$_areas'),
      failsAt(r'$.steps[0].default'),
    );
  });

  test('rejects a focus question that is not a multi step', () {
    expect(
      () => parse('{"id":"areas","type":"talk","prompt":"?"}'),
      failsAt(r'$.focusQuestion'),
    );
  });
}
