import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/json_reader.dart';
import 'package:zulu/content/onboarding_script.dart';
import 'package:zulu/domain/onboarding/question_flow.dart';

final script = OnboardingScript.fromJson(JsonReader.decode('o.json', '''
{
  "sections": [{"id":"x","label":"Energy"},{"id":"y","label":"Life"}],
  "foundationGoals": [], "foundationReason": "r", "focusQuestion": "q2", "planRules": [],
  "steps": [
    {"id":"intro","type":"talk","prompt":"Hi"},
    {"id":"q1","type":"single","section":"x","prompt":"1","options":[{"id":"a","label":"A"},{"id":"b","label":"B"}]},
    {"id":"q2","type":"multi","section":"x","prompt":"2","options":[{"id":"p","label":"P"},{"id":"q","label":"Q"}]},
    {"id":"f1","type":"single","section":"x","prompt":"3","showIf":{"question":"q2","includes":"p"},"options":[{"id":"z","label":"Z"},{"id":"w","label":"W"}]},
    {"id":"f2","type":"talk","section":"x","prompt":"4","showIf":{"question":"f1","equals":"z"}},
    {"id":"q3","type":"single","section":"y","prompt":"5","options":[{"id":"a","label":"A"},{"id":"b","label":"B"}]}
  ]
}
'''));

final flow = QuestionFlow(script);

void main() {
  test('follow-ups stay hidden until their answer is chosen', () {
    expect(flow.visibleSteps({}).map((s) => s.id), ['intro', 'q1', 'q2', 'q3']);
    expect(flow.visibleSteps({'q2': ['p']}).map((s) => s.id), ['intro', 'q1', 'q2', 'f1', 'q3']);
    expect(flow.visibleSteps({'q2': ['p'], 'f1': 'z'}).map((s) => s.id), ['intro', 'q1', 'q2', 'f1', 'f2', 'q3']);
  });

  test('next skips hidden steps and ends with null', () {
    expect(flow.next('q2', {'q2': ['q']})!.id, 'q3');
    expect(flow.next('q2', {'q2': ['p']})!.id, 'f1');
    expect(flow.next('q3', {}), isNull);
  });

  test('previous skips hidden steps and stops at the start', () {
    expect(flow.previous('q3', {'q2': ['q']})!.id, 'q2');
    expect(flow.previous('q3', {'q2': ['p'], 'f1': 'w'})!.id, 'f1');
    expect(flow.previous('intro', {}), isNull);
  });

  test('progress counts visible steps within the section', () {
    final plain = flow.progress('q2', {'q2': ['q']})!;
    expect(plain.sectionIndex, 0);
    expect(plain.sectionCount, 2);
    expect(plain.label, 'Energy');
    expect(plain.withinSection, 0.5);
    expect(flow.progress('q2', {'q2': ['p']})!.withinSection, closeTo(1 / 3, 1e-9));
    expect(flow.progress('q3', {})!.sectionIndex, 1);
    expect(flow.progress('q3', {})!.withinSection, 0);
    expect(flow.progress('intro', {}), isNull);
  });

  test('prune drops answers of hidden steps, cascading', () {
    final answers = {'q1': 'a', 'q2': ['q'], 'f1': 'z', 'f2': 'ok'};
    expect(flow.prune(answers), {'q1': 'a', 'q2': ['q']});
  });

  test('prune drops answers for steps that no longer exist', () {
    expect(flow.prune({'q1': 'b', 'removed_step': 'x'}), {'q1': 'b'});
  });

  test('resumeAt finds the first visible step without an answer', () {
    expect(flow.resumeAt({})!.id, 'intro');
    expect(flow.resumeAt({'intro': 'ok', 'q1': 'a', 'q2': ['p']})!.id, 'f1');
    expect(flow.resumeAt({'intro': 'ok', 'q1': 'a', 'q2': ['q'], 'q3': 'b'}), isNull);
  });
}
